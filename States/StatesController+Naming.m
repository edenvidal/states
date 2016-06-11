//
//  StatesController+Naming.m
//  States
//
//  Created by Dmitry Rodionov on 06/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStateDescription.h"
#import "NSArray+HigherOrder.h"
#import "StatesController+Naming.h"

@implementation StatesController (Naming)

/// Enumerates names such as "State", "State 1", "State 2" etc and returns the first available one
- (NSString *)newStateNameInStates: (NSArray <STStateDescription *> *)existingStates
{
	static NSString *template = @"State";
	NSSet *matchedNames = [NSSet setWithArray: [existingStates rd_map: ^NSString *(STStateDescription *state) {
		return state.title;
	}]];

	NSInteger idx = 1;
	NSString *newName = template;
	while ([matchedNames containsObject: newName]) {
		newName = [NSString stringWithFormat: @"%@ %ld", template, idx++];
	}

	return newName;
}

@end
