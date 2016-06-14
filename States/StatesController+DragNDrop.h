// StatesController+DragNDrop.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "StatesController.h"

@interface StatesController (DragNDrop)

- (void)registerTableViewForDragNDrop;

// This category also implements the following NSTableViewDataSources methods:

- (BOOL)tableView: (NSTableView *)tableView writeRowsWithIndexes: (NSIndexSet *)rowIndexes toPasteboard: (NSPasteboard *)pboard;

- (NSDragOperation)tableView: (NSTableView *)tableView validateDrop: (id <NSDraggingInfo>)info proposedRow: (NSInteger)row proposedDropOperation: (NSTableViewDropOperation)dropOperation;

- (BOOL)tableView: (NSTableView *)tableView acceptDrop: (id <NSDraggingInfo>)info row: (NSInteger)row dropOperation: (NSTableViewDropOperation)dropOperation;

@end
