//
//  STColorFactory.m
//  States
//
//  Created by Dmitry Rodionov on 10/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STColorFactory.h"

@implementation STColorFactory

+ (NSColor *)selectedTableViewRowColor
{
	return [NSColor colorWithRed: 110.f/255.f green: 157.f/255.f blue: 228.f/255.f  alpha: 1.0f];
}

+ (NSColor *)selectedInactiveTableViewRowColor
{
	return [NSColor colorWithRed: 200.f/255.f green: 200.f/255.f blue: 200.f/255.f  alpha: 1.0f];
}

+ (NSColor *)tableViewBackgroundColor
{
	return [NSColor colorWithRed: 236.f/255.f green: 236.f/255.f blue: 236.f/255.f alpha: 1.0f];
}

+ (NSColor *)mainTableViewRowColor
{
	return [NSColor colorWithRed: 240.f/255.f green: 240.f/255.f blue: 240.f/255.f alpha: 1.0f];
}

+ (NSColor *)secondaryTableViewRowColor
{
	return [NSColor colorWithRed: 235.f/255.f green: 235.f/255.f blue: 235.f/255.f alpha: 1.0f];
}

+ (NSColor *)tableViewCellTextRegularColor
{
	return [NSColor controlTextColor];
}

+ (NSColor *)tableViewCellTextSelectedColorWithAlpha: (CGFloat)alpha
{
	return [NSColor colorWithWhite: 10 alpha: alpha];
}

+ (NSColor *)tableViewCellTextInactiveSelectedColorWithAlpha: (CGFloat)alpha
{
	return [NSColor colorWithWhite: 5 alpha: alpha];
}

+ (NSColor *)headerViewBackgroundColor
{
	return [NSColor colorWithRed: 243.f/255.f green: 243.f/255.f blue: 243.f/255.f alpha: 1.0f];
}

+ (NSColor *)headerViewBorderColor
{
	return [NSColor colorWithRed: 184.f/255.f green: 184.f/255.f blue: 184.f/255.f alpha: 1.0f];
}

+ (NSColor *)placeholderViewBackground
{
	return [NSColor colorWithRed: 236.f/255.f green: 236.f/255.f blue: 236.f/255.f alpha: 1.0f];
}

@end
