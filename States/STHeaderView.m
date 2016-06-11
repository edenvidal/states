//
//  STHeaderView.m
//  States
//
//  Created by Dmitry Rodionov on 10/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
