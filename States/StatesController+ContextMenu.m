//
//  StatesController+ContextMenu.m
//  States
//
//  Created by Dmitry Rodionov on 06/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStateDescription.h"
#import "STStatefulArtboard.h"
#import "StatesController+ContextMenu.h"

@implementation StatesController (ContextMenu)

- (void)menuNeedsUpdate: (NSMenu *)menu
{
	[menu removeAllItems];

	NSInteger clickedRow = [self.tableView clickedRow];
	if (clickedRow < 0 || clickedRow >= _artboard.allStates.count) {
		return;
	}

	STStateDescription *state = _artboard.allStates[clickedRow];
	// TODO: add support for updating non-current states as well. Need to figure out
	// when "updating" them means though. Maybe just rewriting them to reflect current artboard properties?
	if ([state isEqual: _artboard.currentState]) {
		NSMenuItem *updateItem = [[NSMenuItem alloc] initWithTitle: @"Update"
															action: @selector(updateCurrentState:) keyEquivalent: @""];
		updateItem.target = self;
		updateItem.representedObject = state;
		[menu addItem: updateItem];
	}

	NSMenuItem *duplicateItem = [[NSMenuItem alloc] initWithTitle: @"Duplicate"
														   action: @selector(duplicateState:) keyEquivalent: @""];
	duplicateItem.target = self;
	duplicateItem.representedObject = state;
	[menu addItem: duplicateItem];

	// TODO: implement this one
	//	NSMenuItem *createPageItem = [[NSMenuItem alloc] initWithTitle: @"Create Page"
	//															action: nil keyEquivalent: @""];
	//	createPageItem.target = self;
	//	createPageItem.representedObject = state;
	//	createPageItem.enabled = NO; // FIXME: see TODO above
	//	[menu addItem: createPageItem];

	if ([state isNotEqualTo: _artboard.defaultState]) {
		NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle: @"Delete"
															action: @selector(deleteState:) keyEquivalent: @""];
		deleteItem.target = self;
		deleteItem.representedObject = state;
		[menu addItem: [NSMenuItem separatorItem]];
		[menu addItem: deleteItem];
	}
}

@end
