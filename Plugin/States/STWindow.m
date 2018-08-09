// STWindow.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

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
