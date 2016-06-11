//
//  STColorFactory.h
//  States
//
//  Created by Dmitry Rodionov on 10/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface STColorFactory : NSObject

// Table View Colors

+ (NSColor *)selectedTableViewRowColor;

+ (NSColor *)selectedInactiveTableViewRowColor;

+ (NSColor *)mainTableViewRowColor;

+ (NSColor *)secondaryTableViewRowColor;

+ (NSColor *)tableViewBackgroundColor;

// Header Colors

+ (NSColor *)headerViewBackgroundColor;
+ (NSColor *)headerViewBorderColor;

// Placeholder Colors

+ (NSColor *)placeholderViewBackground;

@end
