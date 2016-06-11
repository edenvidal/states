//
//  STTableRowView.m
//  States
//
//  Created by Dmitry Rodionov on 10/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STColorFactory.h"
#import "STTableRowView.h"

@interface STTableRowView()
@property (readwrite, weak) NSTableView *tableView;
@end

@implementation STTableRowView

- (instancetype)initWithTableView:(NSTableView *)containingTableView
{
	if ((self = [super initWithFrame: NSZeroRect])) {
		_tableView = containingTableView;
	}
	return self;
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect
{
	[super drawBackgroundInRect: dirtyRect];
	NSInteger row = [self.tableView rowForView: self];
	if (row % 2 == 0) {
		[[STColorFactory mainTableViewRowColor] setFill];
	} else {
		[[STColorFactory secondaryTableViewRowColor] setFill];
	}
	NSBezierPath *path = [NSBezierPath bezierPathWithRect: dirtyRect];
	[path fill];
}

- (void)drawSelectionInRect: (NSRect)dirtyRect
{
	[super drawBackgroundInRect: dirtyRect];
	if (self.emphasized) {
		[[STColorFactory selectedTableViewRowColor] setFill];
	} else {
		[[STColorFactory selectedInactiveTableViewRowColor] setFill];
	}
	NSBezierPath *path = [NSBezierPath bezierPathWithRect: dirtyRect];
	[path fill];
}

@end
