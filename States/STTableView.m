// STTableView.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


#import "STColorFactory.h"
#import "STTableView.h"

@implementation STTableView

- (void)keyDown: (NSEvent *)theEvent
{
	NSString *characters = [theEvent charactersIgnoringModifiers];
	unichar code = [characters characterAtIndex: 0];
	// Disable arrow keys navigation
	switch (code) {
		case NSUpArrowFunctionKey:
		case NSDownArrowFunctionKey:
		case NSLeftArrowFunctionKey:
		case NSRightArrowFunctionKey:
			return;
		default:
			[super keyDown: theEvent];
	}
}

- (void)drawBackgroundInClipRect: (NSRect)clipRect
{
	[super drawBackgroundInClipRect: clipRect];

	[[STColorFactory tableViewBackgroundColor] setFill];
	NSBezierPath *path = [NSBezierPath bezierPathWithRect: clipRect];
	[path fill];
}

@end
