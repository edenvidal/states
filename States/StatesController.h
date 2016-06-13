//
//  StatesController.h
//  States
//
//  Created by Dmitry Rodionov on 31/05/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

@class STStatefulArtboard;
@class STUpdateButton;
@class STTableCellView;

@interface StatesController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>
{
@protected
	STStatefulArtboard *_artboard;
}
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet STUpdateButton *addNewStateButton;
@property (weak) IBOutlet NSView *placeholderView;

+ (instancetype)defaultController;

/// XXX
- (void)createNewState: (id)sender;
/// XXX
- (void)updateCurrentState: (NSMenuItem *)sender;
/// XXX
- (void)duplicateStates: (NSMenuItem *)sender;
/// XXX
- (void)createPageFromStates: (NSMenuItem *)sender;
/// XXX
- (void)deleteStates: (NSMenuItem *)sender;

@end
