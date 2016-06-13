//
//  StatesController+Decisions.m
//  States
//
//  Created by Dmitry Rodionov on 06/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStateDescription.h"
#import "STStatefulArtboard.h"
#import "NSArray+HigherOrder.h"
#import "StatesController+Decisions.h"

#define kNumberOfStatesToShowInDeleteAlert (10)

@implementation StatesController (Decisions)

- (BOOL)shouldSwitchToState: (STStateDescription *)newState fromState: (STStateDescription *)oldState
{
	// If there aren't any changes then the switch is safe
	if ([_artboard conformsToState: oldState]) {
		return YES;
	}

	/// XXX
	if ([oldState isEqual: newState]) {
		NSAlert *alert = [[NSAlert alloc] init];
		alert.messageText = [NSString stringWithFormat:
							 @"Do you want to revert any changes made to state \"%@\"?", oldState.title];
		[alert addButtonWithTitle: @"Revert changes"];
		[alert addButtonWithTitle: @"Cancel"];

		NSModalResponse response = [alert runModal];
		switch (response) {
			case NSAlertFirstButtonReturn:
				// "Revert": allow to re-apply this state
				return YES;
			case NSAlertSecondButtonReturn:
				// "Cancel": do nothing
				return NO;
			default:
				return NO;
		}
	} else {
		NSAlert *alert = [[NSAlert alloc] init];
		alert.messageText = [NSString stringWithFormat:
							 @"Update changes to state \"%@\" before switching to \"%@\"?",
							 oldState.title, newState.title];
		[alert addButtonWithTitle: @"Update"];
		[alert addButtonWithTitle: @"Cancel"];
		[alert addButtonWithTitle: @"Don’t Update"];

		NSModalResponse response = [alert runModal];
		switch (response) {
			case NSAlertFirstButtonReturn:
				// "Update": update the current state and switch to a new one
				[_artboard updateCurrentState];
				return YES;
			case NSAlertSecondButtonReturn:
				// "Cancel": do nothing
				return NO;
			case NSAlertThirdButtonReturn:
				// "Do not update": so to say, just switch to the new state
				return YES;
			default:
				return NO;
		}
	}
}

- (BOOL)shoulRemoveStates: (NSArray <STStateDescription *> *)states
{
	NSParameterAssert(states.count > 0);

	NSArray <NSString *>*titles = [states rd_map: ^NSString *(STStateDescription *state) {
		return [NSString stringWithFormat: @"\t• %@", state.title];
	}];

	if (titles.count > kNumberOfStatesToShowInDeleteAlert) {
		NSInteger total = titles.count;
		titles = [titles subarrayWithRange: NSMakeRange(0, kNumberOfStatesToShowInDeleteAlert)];
		titles = [titles arrayByAddingObject: [NSString stringWithFormat: @"\t(and %ld more)",
											   total-kNumberOfStatesToShowInDeleteAlert]];
	}

	NSAlert *alert = [[NSAlert alloc] init];
	if (titles.count == 1) {
		alert.messageText = [NSString stringWithFormat:
							 @"Do you want to delete state \"%@\"?", states.firstObject.title];
	} else {
		alert.messageText = [NSString stringWithFormat:
							 @"Do you want to delete the following states:\n%@",
							 [titles componentsJoinedByString: @"\n"]];
	}

	alert.informativeText = @"All of the settings on this state will also be removed.";
	[alert addButtonWithTitle: @"Cancel"];
	[alert addButtonWithTitle: @"Delete"];

	NSModalResponse response = [alert runModal];
	switch (response) {
		case NSAlertFirstButtonReturn:
			// "Cancel"
			return NO;
		case NSAlertSecondButtonReturn:
			// "Delete"
			return YES;
		default:
			return NO;
	}
}


@end
