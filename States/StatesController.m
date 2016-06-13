//
//  StatesController.m
//  States
//
//  Created by Dmitry Rodionov on 31/05/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STSketch.h"
#import "STTextField.h"
#import "STTableRowView.h"
#import "STColorFactory.h"
#import "STTableCellView.h"
#import "NSArray+Indexes.h"
#import "STStatefulArtboard.h"
#import "StatesController.h"
#import "StatesController+Naming.h"
#import "StatesController+Decisions.h"
#import "StatesController+DragNDrop.h"
#import "StatesController+ContextMenu.h"

@interface StatesController()
<SketchNotificationsListener, NSTextFieldDelegate, STTextFieldFirstResponderDelegate, STTableRowViewDelegate>
@end

@implementation StatesController

+ (instancetype)defaultController
{
	static StatesController *controller = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		controller = [[StatesController alloc] init];
		[[STSketch notificationObserver] addListener: controller];
	});
	return controller;
}

- (NSString *)windowNibName
{
	return @"StatesWindow";
}

- (void)awakeFromNib
{
	[(NSPanel *)self.window setWorksWhenModal: NO];
	[(NSPanel *)self.window setFloatingPanel: YES];

	/// NOTE: these two images came from Sketch's own Resources
	self.addNewStateButton.image = [NSImage imageNamed: @"pages_add"];
	self.addNewStateButton.alternateImage = [NSImage imageNamed: @"pages_add_pressed"];
	self.addNewStateButton.toolTip = @"Add a new state which will reflect the current artboard parameters";

	self.tableView.menu = [NSMenu new];
	self.tableView.menu.delegate = self;
	self.tableView.action = @selector(singleClicked:);
	self.tableView.doubleAction = @selector(doubleClicked:);
	[self registerTableViewForDragNDrop];

	[self resetArtboard: [STSketch currentArtboard]];
}

- (void)resetArtboard: (STStatefulArtboard *)artboard
{
	_artboard = artboard;
	[self.tableView reloadData];

	if (!_artboard) {
		self.placeholderView.hidden = NO;
		self.addNewStateButton.enabled = NO;
		return;
	}

	self.placeholderView.hidden = YES;
	self.addNewStateButton.enabled = YES;

	// Pre-select the current state (if any)
	NSUInteger currentStateIndex = [_artboard.allStates indexOfObject: _artboard.currentState];
	if (currentStateIndex != NSNotFound) {
		[self.tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: currentStateIndex]
					byExtendingSelection: NO];
	}
}

#pragma mark - SketchNotificationsListener

- (void)currentArtboardDidChange
{
	[self resetArtboard: [STSketch currentArtboard]];
}

- (void)currentArtboardUnselected
{
	[self resetArtboard: nil];
}

- (void)currentDocumentUpdated
{
	if (!_artboard.currentState) {
		return;
	}
	[self resetDirtyMarkOnStates];
}

#pragma mark - Dirty States

- (void)resetDirtyMarkOnStates
{
	// Show an update button if needed
	[_artboard.allStates enumerateObjectsUsingBlock: ^(STStateDescription *state, NSUInteger idx, BOOL *stop) {
		STTableCellView *cell = [self.tableView viewAtColumn: 0 row: idx makeIfNecessary: NO];
		if ([state isEqualTo: _artboard.currentState] && ([self.tableView editedRow] != idx)) {
			cell.updateButton.animator.hidden = [_artboard conformsToState: state];
		} else {
			cell.updateButton.animator.hidden = YES;
		}
	}];
}

#pragma mark - Public Information

- (STTableCellView *)cellViewRepresentingCurrentState
{
	NSInteger idx = [_artboard.allStates indexOfObject: _artboard.currentState];
	if (!_artboard || idx == NSNotFound) {
		return nil;
	}
	return [self.tableView viewAtColumn: 0 row: idx makeIfNecessary: NO];
}

#pragma mark - User Actions

- (IBAction)createNewState: (id)sender
{
	NSString *newStateName = [self newStateNameInStates: _artboard.allStates];
	STStateDescription *state = [[STStateDescription alloc] initWithTitle: newStateName];

	[_artboard insertNewState: state];

	// Update the table view
	NSInteger newIndex = _artboard.allStates.count-1;
	[self.tableView insertRowsAtIndexes: [NSIndexSet indexSetWithIndex: newIndex]
						  withAnimation: NSTableViewAnimationEffectFade];
	// No need to ask user about switching, since the settings are already saved in this new state
	[self.tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: newIndex] byExtendingSelection: NO];
	// HACK: avoid re-apply the same artboard properties which can take a lot of time on big artboards
	[_artboard setCurrentState: state];
	[self resetDirtyMarkOnStates];
	// Move focus to the row to allow user to immdiately change the title value
	[self.tableView editColumn: 0 row: newIndex withEvent: nil select: YES];
}

- (IBAction)updateCurrentState: (NSMenuItem *)sender
{
	NSInteger idx = [_artboard.allStates indexOfObject: _artboard.currentState];
	NSParameterAssert(idx != NSNotFound);

	STTableCellView *cell = [self.tableView viewAtColumn: 0 row: idx makeIfNecessary: NO];

	__block BOOL animationCompleted = NO;
	[cell.updateButton spinWithCompletion: ^{
		[self resetDirtyMarkOnStates];
		animationCompleted = YES;
	}];

	[_artboard updateCurrentState];
	
	if (animationCompleted) {
		[self resetDirtyMarkOnStates];
	}
}

- (IBAction)duplicateStates: (NSMenuItem *)sender
{
	NSArray <STStateDescription *> *originals = sender.representedObject;
	NSParameterAssert([originals isKindOfClass: [NSArray class]]);

	[originals enumerateObjectsUsingBlock: ^(STStateDescription *state, NSUInteger idx, BOOL *stop) {
		NSString *duplicateTitle = [NSString stringWithFormat: @"%@ copy", state.title];
		STStateDescription *duplicate = [[STStateDescription alloc] initWithTitle: duplicateTitle];
		[_artboard insertNewState: duplicate];
		[_artboard copyState: state toState: duplicate];
	}];
	// Update the table view
	NSRange newStatesRange = NSMakeRange(_artboard.allStates.count-1, originals.count);
	NSIndexSet *newIndexes = [NSIndexSet indexSetWithIndexesInRange: newStatesRange];
	[self.tableView insertRowsAtIndexes: newIndexes
						  withAnimation: NSTableViewAnimationEffectFade];
}

- (void)createPageFromStates: (NSMenuItem *)sender
{
	NSAssert(NO, @"Not Implemented Yet");
}

- (IBAction)deleteStates: (NSMenuItem *)sender
{
	NSMutableArray <STStateDescription *> *statesToDelete = [sender.representedObject mutableCopy];
	NSParameterAssert([statesToDelete isKindOfClass: [NSArray class]]);

	// We can not remove the default state so just remove if from the proposed set of states
	[statesToDelete removeObject: _artboard.defaultState];

	if (![self shoulRemoveStates: statesToDelete]) {
		return;
	}
	NSIndexSet *indexesToDelete = [_artboard.allStates rd_indexesOfObjects: statesToDelete];
	// 1) remove states from data model
	[statesToDelete enumerateObjectsUsingBlock: ^(STStateDescription *state, NSUInteger idx, BOOL *stop) {
		[_artboard removeState: state];
	}];
	// 2) remove corresponding rows from table view
	[self.tableView removeRowsAtIndexes: indexesToDelete withAnimation: NSTableViewAnimationEffectFade];
	// 3) update table view selection
	NSInteger newCurrentState = [_artboard.allStates indexOfObject: _artboard.currentState];
	if (newCurrentState != NSNotFound) {
		[self.tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: newCurrentState]
					byExtendingSelection: NO];
	}
}

- (void)singleClicked: (id)sender
{
	// Ignore clicks when multiple rows are selected
	if ([self.tableView selectedRowIndexes].count > 1) {
		return;
	}

	NSInteger row = [self.tableView clickedRow];
	if (row < 0 || row >= _artboard.allStates.count) {
		return;
	}
	STStateDescription *newState = _artboard.allStates[row];
	if (!newState) {
		return;
	}
	// Clicking on the same state will drop any current changes so we ask user about it
	if ([newState isEqualTo: _artboard.currentState]) {
		if ([self shouldSwitchToState: _artboard.currentState fromState: _artboard.currentState]) {
			[_artboard applyState: newState];
		}
		return;
	}
	// -tableView:shouldSelectRow: has been called already so we just check if the target row
	// is selected and apply the new state accordingly.
	if ([self.tableView isRowSelected: row]) {
		[_artboard applyState: newState];
		[self resetDirtyMarkOnStates];
	}
}

- (void)doubleClicked: (id)sender
{
	// Ignore clicks when multiple rows are selected
	if ([self.tableView selectedRowIndexes].count > 1) {
		return;
	}

	NSInteger row = [self.tableView clickedRow];
	if (row < 0 || row >= _artboard.allStates.count) {
		return;
	}
	[self.tableView editColumn: 0 row: row withEvent: nil select: YES];
}

#pragma mark User Did Commit New State Title

- (void)controlTextDidEndEditing: (NSNotification *)obj
{
	NSTextView *editor = [obj.userInfo valueForKey: @"NSFieldEditor"];
	NSInteger updatedRow = [self.tableView rowForView: editor];
	if (updatedRow < 0 || updatedRow >= _artboard.allStates.count) {
		return;
	}

	NSString *newTitle = [[editor string] stringByTrimmingCharactersInSet:
						  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (newTitle.length > 0) {
		[_artboard updateName: newTitle forState: _artboard.allStates[updatedRow]];
	} else {
		[self.tableView reloadDataForRowIndexes: [NSIndexSet indexSetWithIndex: updatedRow]
								  columnIndexes: [NSIndexSet indexSetWithIndex: 0]];
	}
	[self resetDirtyMarkOnStates];
}

/// XXX
- (void)textFieldBecomeFirstResponder: (NSTextField *)textField
{
	NSInteger row = [self.tableView rowForView: textField];
	if (row < 0 || row >= _artboard.allStates.count) {
		return;
	}
	STTableCellView *cell = [self.tableView viewAtColumn: 0 row: row makeIfNecessary:NO];
	cell.updateButton.hidden = YES;
}

#pragma mark - NSTableViewDataSource & NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView: (NSTableView *)tableView
{
	return _artboard.allStates.count;
}

- (NSView *)tableView: (NSTableView *)tableView viewForTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)row
{
	STStateDescription *state = _artboard.allStates[row];
	if (!state) {
		return nil;
	}
	STTableCellView *cellView = [tableView makeViewWithIdentifier: @"StateCell" owner: nil];
	if (!cellView) {
		return nil;
	}
	// XXX
	cellView.textField.stringValue = state.title;
	cellView.textField.delegate = self;
	((STTextField *)cellView.textField).firstResponderDelegate = self;
	// XXX
	cellView.updateButton.action = @selector(updateCurrentState:);
	cellView.updateButton.target = self;
	// XXX
	if ([[tableView selectedRowIndexes] containsIndex: row]) {
		cellView.updateButton.hidden = [_artboard conformsToState: state];
	} else {
		cellView.updateButton.hidden = YES;
	}
	return cellView;
}

#pragma mark Selection Filter

- (NSIndexSet *)tableView: (NSTableView *)tableView selectionIndexesForProposedSelection: (NSIndexSet *)proposedSelectionIndexes
{
	// Don't allow table view to reset selection automatically from multiple rows to "nothing". In
	// this case it will select the last row which may not represent the current state
	if ([tableView selectedRowIndexes].count > 1 && proposedSelectionIndexes.count == 0) {
		NSInteger currentRow = [tableView rowForView: [self cellViewRepresentingCurrentState]];
		return [NSIndexSet indexSetWithIndex: currentRow];
	}
	// Redraw the already selected row when we're dropping multiselection to just this one row
	if ([tableView selectedRowIndexes].count > 1 && proposedSelectionIndexes.count == 1) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
									 (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
		^{
			[self.tableView rowViewAtRow: proposedSelectionIndexes.firstIndex
						 makeIfNecessary: NO].needsDisplay = YES;
		});
	}
	return proposedSelectionIndexes;
}

- (BOOL)tableView: (NSTableView *)tableView shouldSelectRow: (NSInteger)row
{
	// Always allow to expand selection. Note that we don't switch states in this case
	NSEventModifierFlags flags = [NSApp currentEvent].modifierFlags;
	NSEventType type = [NSApp currentEvent].type;

	BOOL cmdPressed   = (flags & NSCommandKeyMask) == NSCommandKeyMask;
	BOOL shiftPressed = (flags & NSShiftKeyMask) == NSShiftKeyMask;
	BOOL leftMouseDragged = (type == NSLeftMouseDragged);

	if (cmdPressed || shiftPressed || leftMouseDragged) {
		return YES;
	}

	NSInteger previouslySelectedRow = [tableView selectedRow];
	if (previouslySelectedRow == -1) {
		return YES;
	}

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.tableView rowViewAtRow: row makeIfNecessary: NO].needsDisplay = YES;
	});

	STStateDescription *oldState = _artboard.allStates[previouslySelectedRow];
	STStateDescription *newState = _artboard.allStates[row];
	return [self shouldSwitchToState: newState fromState: oldState];
}

#pragma mark Row Coloring

- (NSTableRowView *)tableView: (NSTableView *)tableView rowViewForRow: (NSInteger)row
{
	STTableRowView *rowView = [[STTableRowView alloc] initWithTableView: tableView];
	rowView.delegate = self;
	return rowView;
}

@end
