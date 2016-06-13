//
//  StatesController+Decisions.h
//  States
//
//  Created by Dmitry Rodionov on 06/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "StatesController.h"

@class STStateDescription;

@interface StatesController (Decisions)

/// XXX
- (BOOL)shouldSwitchToState: (STStateDescription *)newState fromState: (STStateDescription *)oldState;
/// XXX
- (BOOL)shoulRemoveStates: (NSArray <STStateDescription *> *)states;

@end
