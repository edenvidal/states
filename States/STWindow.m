//
//  STWindow.m
//  States
//
//  Created by Dmitry Rodionov on 09/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STWindow.h"

@implementation STWindow

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (BOOL)isMovableByWindowBackground
{
	return YES;
}

@end
