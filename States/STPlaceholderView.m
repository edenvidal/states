//
//  STPlaceholderView.m
//  States
//
//  Created by Dmitry Rodionov on 10/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
