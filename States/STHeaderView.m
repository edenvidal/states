// STHeaderView.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STColorFactory.h"
#import "STHeaderView.h"

#define kHeaderViewBorderWidth (1.0f)

@implementation STHeaderView

- (void)awakeFromNib
{
	self.wantsLayer = YES;
}

- (BOOL)wantsUpdateLayer
{
	return YES;
}

- (void)updateLayer
{
	// Setup a background
	self.layer.backgroundColor = [STColorFactory headerViewBackgroundColor].CGColor;
	// Draw a border at the buttom of the header
	CALayer *buttomBorder = [CALayer layer];
	buttomBorder.borderColor = [STColorFactory headerViewBorderColor].CGColor;
	buttomBorder.borderWidth = kHeaderViewBorderWidth;
	buttomBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kHeaderViewBorderWidth);

	[self.layer addSublayer: buttomBorder];
}

@end
