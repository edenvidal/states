// StatesController+ContextMenu.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "StatesController.h"

/// A category that builds a context menu for selected rows
@interface StatesController (ContextMenu) <NSMenuDelegate>

- (void)menuNeedsUpdate: (NSMenu *)menu;

@end
