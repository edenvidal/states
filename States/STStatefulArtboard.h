//
//  StatefulArtboard.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;
#import "STStateDescription.h"
#import "STSketchPluginContext.h"
#import "STArtboard.h"

@interface STStatefulArtboard : NSObject <STArtboard>
{
@protected
	id <STArtboard> _internal;
}
/// XXX
@property (readonly, strong) STSketchPluginContext *context;
/// XXX
@property (readonly, strong) NSArray <STStateDescription *> *allStates;
/// XXX
@property (readonly, strong) STStateDescription *currentState;
/// XXX
@property (readonly, strong) STStateDescription *defaultState;

/// XXX
- (instancetype)initWithArtboard: (id <STArtboard>)artboard context: (STSketchPluginContext *)context;

/// XXX
- (BOOL)conformsToState: (STStateDescription *)state;

/// Restore artboard state from `state`.
- (void)applyState: (STStateDescription *)state;

/// Save current artboard state.
- (void)updateCurrentState;

/// XXX
- (void)insertNewState: (STStateDescription *)newState;

/// XXX
- (void)copyState: (STStateDescription *)source toState: (STStateDescription *)destination;

/// XXX
- (STStateDescription *)updateName: (NSString *)newName forState: (STStateDescription *)existingState;

/// XXX
- (void)reorderStates: (NSArray <STStateDescription *> *)allStatesInNewOrder;

/// XXX
- (void)removeState: (STStateDescription *)stateToRemove;

/// XXX
- (void)removeAllStates;


/// DANGEROUS 🚫

- (void)setCurrentState: (STStateDescription *)currentState;

@end
