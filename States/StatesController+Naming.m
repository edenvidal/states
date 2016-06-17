// StatesController+Naming.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STStateDescription.h"
#import "NSArray+HigherOrder.h"
#import "StatesController+Naming.h"

@implementation StatesController (Naming)

/// Enumerates names such as "State", "State 1", "State 2" etc and returns the first available one
- (NSString *)newStateNameInStates: (NSArray <STStateDescription *> *)existingStates
{
	static NSString *template = @"State";
	NSSet *matchedNames = [NSSet setWithArray:
						   [existingStates st_map: ^NSString *(STStateDescription *state) {
		return state.title;
	}]];

	NSInteger idx = 1;
	NSString *newName = template;
	while ([matchedNames containsObject: newName]) {
		newName = [NSString stringWithFormat: @"%@ %ld", template, idx++];
	}

	return newName;
}

- (NSString *)pageNameForStates: (NSArray <STStateDescription *> *)states
{
	NSString *titles = [[states st_map: ^NSString *(STStateDescription *state) {
		return state.title;
	}] componentsJoinedByString: @", "];

	return [NSString stringWithFormat: @"Page for %@", titles];
}

@end
