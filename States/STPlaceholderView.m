// STPlaceholderView.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


#import "STColorFactory.h"
#import "STPlaceholderView.h"

@implementation STPlaceholderView

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
	self.layer.backgroundColor = [STColorFactory placeholderViewBackground].CGColor;
}

@end
