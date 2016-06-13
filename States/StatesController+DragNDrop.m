//
//  StatesController+DragNDrop.m
//  States
//
//  Created by Dmitry Rodionov on 13/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStatefulArtboard.h"
#import "StatesController+DragNDrop.h"

@implementation StatesController (DragNDrop)

- (BOOL)tableView: (NSTableView *)tableView writeRowsWithIndexes: (NSIndexSet *)rowIndexes toPasteboard: (NSPasteboard *)pboard
{
	NSData *indexesData = [NSKeyedArchiver archivedDataWithRootObject: rowIndexes];
	[pboard declareTypes: @[kStatesControllerDraggedType] owner: self];
	[pboard setData: indexesData forType: kStatesControllerDraggedType];
	return YES;
}

- (NSDragOperation)tableView: (NSTableView *)tableView validateDrop: (id <NSDraggingInfo>)info proposedRow: (NSInteger)row proposedDropOperation: (NSTableViewDropOperation)dropOperation
{
	if (dropOperation == NSTableViewDropAbove) {
		[info setAnimatesToDestination: YES];
		return NSDragOperationMove;
	}
	return NSDragOperationNone;
}

- (BOOL)tableView: (NSTableView *)tableView acceptDrop: (id <NSDraggingInfo>)info row: (NSInteger)row dropOperation: (NSTableViewDropOperation)dropOperation
{
	NSData *data = [[info draggingPasteboard] dataForType: kStatesControllerDraggedType];
	NSIndexSet *sourceIndexes = [NSKeyedUnarchiver unarchiveObjectWithData: data];
	//
	// FIXME: support dragging multiple items
	//
	NSUInteger destination = MIN(MAX(row, 0), _artboard.allStates.count-1);
	NSMutableArray *states = [_artboard.allStates mutableCopy];
	NSUInteger source = sourceIndexes.firstIndex;

	// 1) model updates
	id draggedState = [states objectAtIndex: source];
	[states removeObjectAtIndex: source];
	[states insertObject: draggedState atIndex: destination];
	[_artboard reorderStates: states];
	// 2) table view updates
	[tableView moveRowAtIndex: source toIndex: destination];

	return YES;
}

@end
