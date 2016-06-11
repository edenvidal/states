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
- (IBAction)createNewState: (id)sender;
/// XXX
- (IBAction)updateCurrentState: (NSMenuItem *)sender;
/// XXX
- (IBAction)duplicateState: (NSMenuItem *)sender;
/// XXX
- (IBAction)deleteState: (NSMenuItem *)sender;

@end
