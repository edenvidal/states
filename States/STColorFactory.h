// STColorFactory.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Cocoa;

/// Keeps all of the custom colors for this project
@interface STColorFactory : NSObject

// Table View Colors

+ (NSColor *)selectedTableViewRowColor;

+ (NSColor *)selectedInactiveTableViewRowColor;

+ (NSColor *)mainTableViewRowColor;

+ (NSColor *)secondaryTableViewRowColor;

+ (NSColor *)tableViewBackgroundColor;

+ (NSColor *)tableViewCellTextRegularColor;

+ (NSColor *)tableViewCellTextSelectedColorWithAlpha: (CGFloat)alpha;

+ (NSColor *)tableViewCellTextInactiveSelectedColorWithAlpha: (CGFloat)alpha;

// Header Colors

+ (NSColor *)headerViewBackgroundColor;
+ (NSColor *)headerViewBorderColor;

// Placeholder Colors

+ (NSColor *)placeholderViewBackground;

@end
