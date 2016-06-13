//
//  StatesController+Decisions.h
//  States
//
//  Created by Dmitry Rodionov on 06/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "StatesController.h"

@class STStateDescription;

/// A category that asks user's confirmation for (likely) destructive events
@interface StatesController (Decisions)

- (BOOL)shouldSwitchToState: (STStateDescription *)newState fromState: (STStateDescription *)oldState;

- (BOOL)shoulRemoveStates: (NSArray <STStateDescription *> *)states;

@end
