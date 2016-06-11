//
//  StatesController+Naming.h
//  States
//
//  Created by Dmitry Rodionov on 06/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "StatesController.h"
@class STStateDescription;

@interface StatesController (Naming)

/// Enumerates names such as "State", "State 1", "State 2" etc and returns the first available one
- (NSString *)newStateNameInStates: (NSArray <STStateDescription *> *)existingStates;

@end
