//
//  StatefulArtboard.m
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStatefulArtboard.h"
#import "STStatefulArtboard+Backend.h"
#import "STLayerState.h"
#import "NSArray+HigherOrder.h"

#define kArtboardDefaultStateTitle @"Initial State"

@implementation STStatefulArtboard

- (instancetype)initWithArtboard: (id <STArtboard>)artboard context: (STSketchPluginContext *)context
{
	NSParameterAssert(artboard != nil);
	NSParameterAssert(context != nil);

	if ((self = [super init])) {
		_internal = artboard;
		_context = context;
		[self createDefaultLayerIfNeeded];
	}
	return self;
}

- (void)createDefaultLayerIfNeeded
{
	if (self.allStates.count > 0) {
		// Backwards compatibility
		if (!self.defaultState) {
			[self setDefaultState: self.allStates.firstObject];
		}
	} else {
		STStateDescription *defaultState = [[STStateDescription alloc] initWithTitle: kArtboardDefaultStateTitle];
		[self insertNewState: defaultState];
		[self setCurrentState: defaultState];
		[self setDefaultState: defaultState];
	}
}

#pragma mark - STLayer

- (NSArray <id <STLayer>> *)children
{
	return [[_internal children] rd_filter: ^BOOL(id child) {
		return [child class] != NSClassFromString(@"MSArtboardGroup");
	}];
}

#pragma mark - Actions

- (BOOL)conformsToState: (STStateDescription *)state
{
	if (![self.allStates containsObject: state]) {
		return NO;
	}

	__block BOOL result = YES;
	[[self children] enumerateObjectsUsingBlock: ^(id<STLayer> layer, NSUInteger idx, BOOL *stop) {
		NSDictionary *metadata = [self metadataForLayer: layer][state.UUID.UUIDString];
		if (metadata.count == 0) {
			result = NO; *stop = YES;
			return;
		}
		STLayerState *layerState = [[STLayerState alloc] initWithDictionary: metadata];
		if (!layerState || ![STLayerStateExaminer layer: layer conformsToState: layerState]) {
			result = NO; *stop = YES;
		}
	}];
	return result;
}

- (void)removeAllStates
{
	[self setArtboardStatesData: @[]];
	[self setArtboardCurrentStateData: @{}];
	[[self children] enumerateObjectsUsingBlock: ^(id<STLayer> layer, NSUInteger idx, BOOL *stop) {
		[self setMedatada: @{} forLayer: layer];
	}];
}

- (void)removeState: (STStateDescription *)stateToRemove
{
	NSParameterAssert(stateToRemove != nil);
	
	if ([stateToRemove isEqual: self.currentState]) {
		NSInteger idx = [self.allStates indexOfObject: self.currentState];
		NSInteger previousStateIdx = idx - 1;
		NSInteger nextStateIdx = idx + 1;
		if (previousStateIdx >= 0) {
			[self applyState: self.allStates[previousStateIdx]];
		} else if (nextStateIdx < self.allStates.count) {
			[self applyState: self.allStates[nextStateIdx]];
		} else {
			[self setArtboardCurrentStateData: @{}];
		}
	}

	// 1) Remove from artboard state descriptions
	NSArray *statesToKeep = [[self artboardStatesData] rd_filter: ^BOOL(NSDictionary *item) {
		return [item isNotEqualTo: stateToRemove.dictionaryRepresentation];
	}];
	[self setArtboardStatesData: statesToKeep];
	// 2) Remove this state's metadata from layers
	[[self children] enumerateObjectsUsingBlock: ^(id<STLayer> layer, NSUInteger idx, BOOL *stop) {
		NSDictionary *metadata = [self metadataForLayer: layer];
		NSArray *keysToKeep = [metadata.allKeys rd_filter: ^BOOL(NSString *key) {
			return [key isNotEqualTo: stateToRemove.UUID.UUIDString];
		}];
		[self setMedatada: [metadata dictionaryWithValuesForKeys: keysToKeep] forLayer: layer];
	}];
}

- (void)applyState: (STStateDescription *)state
{
	NSParameterAssert([self.allStates containsObject: state]);

	[[self children] enumerateObjectsUsingBlock: ^(id<STLayer> layer, NSUInteger idx, BOOL *stop) {
		NSDictionary *metadata = [self metadataForLayer: layer][state.UUID.UUIDString];
		if (metadata.count == 0) {
			return;
		}
		STLayerState *layerState = [[STLayerState alloc] initWithDictionary: metadata];
		NSAssert(layerState != nil, @"Requested state values are missing from layer's metadata");
		[STLayerStateApplier apply: layerState toLayer: layer];
	}];

	self.currentState = state;
}

- (void)updateCurrentState
{
	STStateDescription *state = self.currentState;
	NSParameterAssert(self.currentState != nil);

	[[self children] enumerateObjectsUsingBlock: ^(id<STLayer> layer, NSUInteger idx, BOOL *stop) {
		NSMutableDictionary *newMetadata = [[self metadataForLayer: layer] mutableCopy];
		STLayerState *layerState = [STLayerStateFetcher fetchStateFromLayer: layer];
		newMetadata[state.UUID.UUIDString] = [layerState dictionaryRepresentation];
		[self setMedatada: newMetadata forLayer: layer];
	}];
}

- (void)copyState: (STStateDescription *)source toState: (STStateDescription *)destination
{
	NSParameterAssert([self.allStates containsObject: source]);
	NSParameterAssert([self.allStates containsObject: destination]);

	// Copy all of the child layers metadata from `source` state to `destination`
	[[self children] enumerateObjectsUsingBlock: ^(id<STLayer> layer, NSUInteger idx, BOOL *stop) {
		NSMutableDictionary *newMetadata = [[self metadataForLayer: layer] mutableCopy];
		NSAssert(newMetadata[source.UUID.UUIDString], @"The source state metadata doesn't exists on layer %@", layer);
		newMetadata[destination.UUID.UUIDString] = newMetadata[source.UUID.UUIDString];
		[self setMedatada: newMetadata forLayer: layer];
	}];
}

- (void)insertNewState: (STStateDescription *)newState
{
	NSParameterAssert(![self.allStates containsObject: newState]);

	// 1) insert this new state into the artboard's registry
	NSArray *oldRawStates = [self artboardStatesData];
	[self setArtboardStatesData: [oldRawStates arrayByAddingObject: newState.dictionaryRepresentation]];

	// 2) update all child layer with the new state: it will be a current layer snapshot
	[[self children] enumerateObjectsUsingBlock: ^(id<STLayer> layer, NSUInteger idx, BOOL *stop) {
		// TODO: this is the same code as in -updateCurrentState (just replace state <-> newState)
		NSMutableDictionary *newMetadata = [[self metadataForLayer: layer] mutableCopy];
		STLayerState *layerState = [STLayerStateFetcher fetchStateFromLayer: layer];
		newMetadata[newState.UUID.UUIDString] = [layerState dictionaryRepresentation];
		[self setMedatada: newMetadata forLayer: layer];
	}];

	if (!self.currentState) {
		[self setCurrentState: newState];
	}
}

- (STStateDescription *)updateName: (NSString *)newName forState: (STStateDescription *)oldState
{
	NSParameterAssert([self.allStates containsObject: oldState]);

	STStateDescription *newState = [oldState stateByAlteringTitle: newName];
	NSMutableArray *stateRegistry = [[self artboardStatesData] mutableCopy];
	NSUInteger idx = [stateRegistry indexOfObject: oldState.dictionaryRepresentation];
	NSAssert(idx != NSNotFound, @"Could not find the given state");
	// Modify a states registry
	[stateRegistry replaceObjectAtIndex: idx withObject: newState.dictionaryRepresentation];
	[self setArtboardStatesData: stateRegistry];
	// Also update the current state if needed
	if ([oldState isEqual: self.currentState]) {
		[self setCurrentState: newState];
	}

	return newState;
}

- (void)reorderStates: (NSArray <STStateDescription *> *)allStatesInNewOrder
{
	NSAssert([[NSSet setWithArray: self.allStates] isEqualToSet: [NSSet setWithArray: allStatesInNewOrder]],
			 @"Invalid argument");
	[self setAllStates: allStatesInNewOrder];
}

#pragma mark - Artboard State Metadata

- (NSArray <STStateDescription *> *)allStates
{
	return [[self artboardStatesData] rd_map: ^STStateDescription *(NSDictionary *model) {
		return [[STStateDescription alloc] initWithDictionary: model];
	}];
}

- (STStateDescription *)currentState
{
	NSDictionary *currentStateData = [self artboardCurrentStateData];
	if (currentStateData.count == 0) {
		return nil;
	}
	return [[STStateDescription alloc] initWithDictionary: currentStateData];
}

- (STStateDescription *)defaultState
{
	NSDictionary *defaultStateDictionary = [self artboardDefaultStateData];
	if (defaultStateDictionary.count == 0) {
		return nil;
	}
	return [[STStateDescription alloc] initWithDictionary: defaultStateDictionary];
}

#pragma mark - Internal Metadata

- (void)setAllStates: (NSArray<STStateDescription *> *)allStates
{
	NSArray *rawStates = [allStates rd_map: ^NSDictionary *(STStateDescription *state) {
		return [state dictionaryRepresentation];
	}];
	[self setArtboardStatesData: rawStates];
}

- (void)setCurrentState: (STStateDescription *)newCurrentState
{
	NSParameterAssert([self.allStates containsObject: newCurrentState]);
	NSDictionary *state = [newCurrentState dictionaryRepresentation];
	[self setArtboardCurrentStateData: state];
}

- (void)setDefaultState: (STStateDescription *)defaultState
{
	NSParameterAssert(self.defaultState == nil);
	NSDictionary *stateDictionary = [defaultState dictionaryRepresentation];
	[self setArtboardDefaultStateData: stateDictionary];
}
@end
