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

/// Well, well, well. Here you are, looking for a big fish. This one is responsible for managing
/// the states table view and responding to user's actions by modifing current artboard.
///
/// It's huge and ungly. But I did my bext to make this controller as stateless (such irony!) as
/// possible so at least one could easily refactor different bits into separate classes 🌟
@interface StatesController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>
{
@protected
	STStatefulArtboard *_artboard;
}
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet STUpdateButton *addNewStateButton;
@property (weak) IBOutlet NSView *placeholderView;

+ (instancetype)defaultController;

/// Creates a new state
- (void)createNewState: (id)sender;
/// Update the current state: make it reflect current artboard attributes
- (void)updateCurrentState: (NSMenuItem *)sender;
/// Create duplicates for all selected states
- (void)duplicateStates: (NSMenuItem *)sender;
/// Create a one page containing as many artboards as selected states: each of them will contain
/// a snapshot of the current artboard in a corresponding state
- (void)createPageFromStates: (NSMenuItem *)sender;
/// Delete all selected states
- (void)deleteStates: (NSMenuItem *)sender;

@end
