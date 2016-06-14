//
//  STTableRowView.h
//  States
//
//  Created by Dmitry Rodionov on 10/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

/// A row view that draws custom background and selection rectangles
@interface STTableRowView : NSTableRowView

@property (readonly, weak) NSTableView *tableView;

- (instancetype)initWithTableView: (NSTableView *)containingTableView;

@end
