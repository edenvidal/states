//
//  STTableView.m
//  States
//
//  Created by Dmitry Rodionov on 05/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: clipRect xRadius: 0.f yRadius: 0.f];
	[path fill];
}

@end
