// StatefulArtboard.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


@import Foundation;
#import "STStateDescription.h"
#import "STSketchPluginContext.h"
#import "STArtboard.h"

/// A wrapper around Sketch's artboard which provides methods for manipulating its state
@interface STStatefulArtboard : NSObject <STArtboard>
{
@protected
	id <STArtboard> _internal;
}
@property (readonly, strong) STSketchPluginContext *context;
@property (readonly, strong) NSArray <STStateDescription *> *allStates;
@property (readonly, strong) STStateDescription *currentState;
@property (readonly, strong) STStateDescription *defaultState;

- (instancetype)initWithArtboard: (id <STArtboard>)artboard context: (STSketchPluginContext *)context;

/// Verifies that all of this artboard's child layers conforms to the given state model
- (BOOL)conformsToState: (STStateDescription *)state;

/// Restore artboard state from `state`
- (void)applyState: (STStateDescription *)state;

/// Save current artboard state
- (void)updateCurrentState;

/// Inserts a new state model into this artboard's metadata. This new state model will represent
/// the current state of the artboard
- (void)insertNewState: (STStateDescription *)newState;

/// Rewrites all child layers attribites so that the `destination` state becomes equal to the `source` one
- (void)copyState: (STStateDescription *)source toState: (STStateDescription *)destination;

/// Update the given state's name in this artboard's metadata
- (STStateDescription *)updateName: (NSString *)newName forState: (STStateDescription *)existingState;

/// Changes the order of the states in this artboard. A passed array must include all of the states
/// of this artboard and nothing else
- (void)reorderStates: (NSArray <STStateDescription *> *)allStatesInNewOrder;

/// Completely removes the given state from this artboard
- (void)removeState: (STStateDescription *)stateToRemove;

/// Wipes all of the states
- (void)removeAllStates;

/// WARNING: you're not suppposed to call this method. It's here just so -[StatesContoller createNewState:]
/// may call it and workaround a major performance issue with applying states on really big artboards.
/// Eventually this method will go away.
- (void)setCurrentState: (STStateDescription *)currentState;

@end
