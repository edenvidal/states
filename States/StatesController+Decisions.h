// StatesController+Decisions.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "StatesController.h"

@class STStateDescription;

/// A category that asks user's confirmation for (likely) destructive events
@interface StatesController (Decisions)

- (BOOL)shouldSwitchToState: (STStateDescription *)newState fromState: (STStateDescription *)oldState;

- (BOOL)shoulRemoveStates: (NSArray <STStateDescription *> *)states;

@end
