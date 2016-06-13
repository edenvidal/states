//
//  StatesController+DragNDrop.h
//  States
//
//  Created by Dmitry Rodionov on 13/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "StatesController.h"

@interface StatesController (DragNDrop)

// This category implements the following NSTableViewDataSources methods:

- (BOOL)tableView: (NSTableView *)tableView writeRowsWithIndexes: (NSIndexSet *)rowIndexes toPasteboard: (NSPasteboard *)pboard;

- (NSDragOperation)tableView: (NSTableView *)tableView validateDrop: (id <NSDraggingInfo>)info proposedRow: (NSInteger)row proposedDropOperation: (NSTableViewDropOperation)dropOperation;

- (BOOL)tableView: (NSTableView *)tableView acceptDrop: (id <NSDraggingInfo>)info row: (NSInteger)row dropOperation: (NSTableViewDropOperation)dropOperation;

@end
