// STTableRowView.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Cocoa;

/// A row view that draws custom background and selection rectangles
@interface STTableRowView : NSTableRowView

@property (readonly, weak) NSTableView *tableView;

- (instancetype)initWithTableView: (NSTableView *)containingTableView;

@end
