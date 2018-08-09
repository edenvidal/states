// STColorFactory.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.
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
