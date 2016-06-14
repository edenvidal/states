// StatesController+ContextMenu.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STStateDescription.h"
#import "STStatefulArtboard.h"
#import "StatesController+ContextMenu.h"

@implementation StatesController (ContextMenu)

- (void)menuNeedsUpdate: (NSMenu *)menu
{
	[menu removeAllItems];
	// TODO: remove as soon as -createPageFromStates is implemened
	menu.autoenablesItems = NO;

	NSInteger clickedRow = [self.tableView clickedRow];
	if (clickedRow < 0 || clickedRow >= _artboard.allStates.count) {
		return;
	}

	NSArray <STStateDescription *>*selectedStates = [_artboard.allStates objectsAtIndexes:
													 [self.tableView selectedRowIndexes]];
	if (selectedStates.count == 0) {
		return;
	}

	STStateDescription *clickedState = _artboard.allStates[clickedRow];
	// We're clicking an a row that isn't part of current selection: show a menu just for this one row
	if (![selectedStates containsObject: clickedState]) {
		selectedStates = @[clickedState];
	}

	// TODO?: add support for updating non-current states as well. Need to figure out
	// when "updating" them means though. Maybe just rewriting them to reflect current artboard properties?
	if (selectedStates.count == 1 && [clickedState isEqualTo: _artboard.currentState]) {
		[menu addItem: [self updateCurrentStateMenuItem]];
	}

	[menu addItem: [self duplicateMenuItemForStates: selectedStates]];
	[menu addItem: [NSMenuItem separatorItem]];
	[menu addItem: [self createPageMenuItemForStates: selectedStates]];
	if (selectedStates.count > 1 || [selectedStates.firstObject isNotEqualTo: _artboard.defaultState]) {
		[menu addItem: [NSMenuItem separatorItem]];
		[menu addItem: [self deleteMenuItemForStates: selectedStates]];
	}
}

#pragma mark Menu Items

- (NSMenuItem *)updateCurrentStateMenuItem
{
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: @"Update"
												  action: @selector(updateCurrentState:)
										   keyEquivalent: @""];
	item.target = self;
	return item;
}

- (NSMenuItem *)duplicateMenuItemForStates: (NSArray <STStateDescription *> *)subjects
{
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: @"Duplicate"
												  action: @selector(duplicateStates:)
										   keyEquivalent: @""];
	item.target = self;
	item.representedObject = subjects;
	return item;
}

- (NSMenuItem *)createPageMenuItemForStates: (NSArray <STStateDescription *> *)subjects
{
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: @"Create Page"
												  action: @selector(createPageFromStates:)
										   keyEquivalent: @""];
	// TODO: enable it as soon as -createPageFromStates is implemened
	item.enabled = NO;
	item.target = self;
	item.representedObject = subjects;
	return item;
}

- (NSMenuItem *)deleteMenuItemForStates: (NSArray <STStateDescription *> *)subjects
{
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: @"Delete"
												  action: @selector(deleteStates:)
										   keyEquivalent: @""];
	item.target = self;
	item.representedObject = subjects;
	return item;
}

@end
