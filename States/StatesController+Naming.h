// StatesController+Naming.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "StatesController.h"
@class STStateDescription;

/// Naming things is the second hard thing in programming
@interface StatesController (Naming)

/// Enumerates names such as "State", "State 1", "State 2" etc and returns the first available one
- (NSString *)newStateNameInStates: (NSArray <STStateDescription *> *)existingStates;

@end
