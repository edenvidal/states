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
#import "STStatefulArtboard.h"
#import "StatesController.h"
#import "StatesController+Naming.h"
#import "StatesController+Decisions.h"
#import "StatesController+ContextMenu.h"

static NSString * const kStatesControllerDraggedType = @"StatesControllerDraggedType";

@interface StatesController()
<SketchNotificationsListener, NSTextFieldDelegate, STTextFieldFirstResponderDelegate>
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
	[self.tableView registerForDraggedTypes: @[kStatesControllerDraggedType]];

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

- (IBAction)duplicateState: (NSMenuItem *)sender
{
	STStateDescription *original = sender.representedObject;
	NSParameterAssert(original != nil);

	NSString *duplicateTitle = [NSString stringWithFormat: @"%@ copy", original.title];
	STStateDescription *duplicate = [[STStateDescription alloc] initWithTitle: duplicateTitle];

	[_artboard insertNewState: duplicate];
	[_artboard copyState: original toState: duplicate];

	// Update the table view
	NSInteger newIndex = _artboard.allStates.count-1;
	[self.tableView insertRowsAtIndexes: [NSIndexSet indexSetWithIndex: newIndex]
						  withAnimation: NSTableViewAnimationEffectFade];
}

- (IBAction)deleteState: (NSMenuItem *)sender
{
	STStateDescription *stateToDelete = sender.representedObject;
	NSParameterAssert(stateToDelete != nil);
	NSParameterAssert([stateToDelete isNotEqualTo: _artboard.defaultState]);

	if (![self shoulRemoveState: stateToDelete]) {
		return;
	}
	NSInteger idx = [_artboard.allStates indexOfObject: stateToDelete];
	[_artboard removeState: stateToDelete];
	[self.tableView removeRowsAtIndexes: [NSIndexSet indexSetWithIndex: idx]
						  withAnimation: NSTableViewAnimationEffectFade];
	NSInteger newCurrentState = [_artboard.allStates indexOfObject: _artboard.currentState];
	if (newCurrentState != NSNotFound) {
		[self.tableView selectRowIndexes: [NSIndexSet indexSetWithIndex: newCurrentState]
					byExtendingSelection: NO];
	}
}

- (void)singleClicked: (id)sender
{
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
- (void)textFieldBecomeFirstResponder:(NSTextField *)textField
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

- (BOOL)tableView: (NSTableView *)tableView shouldSelectRow: (NSInteger)row
{
	NSInteger previouslySelectedRow = [tableView selectedRow];
	if (previouslySelectedRow == -1) {
		return YES;
	}
	STStateDescription *oldState = _artboard.allStates[previouslySelectedRow];
	STStateDescription *newState = _artboard.allStates[row];
	return [self shouldSwitchToState: newState fromState: oldState];
}

#pragma mark Row Coloring

- (NSTableRowView *)tableView: (NSTableView *)tableView rowViewForRow: (NSInteger)row
{
	return [[STTableRowView alloc] initWithTableView: tableView];
}

#pragma mark Drag'n'Drop

- (BOOL)tableView: (NSTableView *)tableView writeRowsWithIndexes: (NSIndexSet *)rowIndexes toPasteboard: (NSPasteboard *)pboard
{
	NSData *indexesData = [NSKeyedArchiver archivedDataWithRootObject: rowIndexes];
	[pboard declareTypes: @[kStatesControllerDraggedType] owner: self];
	[pboard setData: indexesData forType: kStatesControllerDraggedType];
	return YES;
}

- (NSDragOperation)tableView: (NSTableView *)tableView validateDrop: (id <NSDraggingInfo>)info proposedRow: (NSInteger)row proposedDropOperation: (NSTableViewDropOperation)dropOperation
{
	if (dropOperation == NSTableViewDropAbove) {
		[info setAnimatesToDestination: YES];
		return NSDragOperationMove;
	}
	return NSDragOperationNone;
}

- (BOOL)tableView: (NSTableView *)tableView acceptDrop: (id <NSDraggingInfo>)info row: (NSInteger)row dropOperation: (NSTableViewDropOperation)dropOperation
{
	NSData *data = [[info draggingPasteboard] dataForType: kStatesControllerDraggedType];
	NSIndexSet *sourceIndexes = [NSKeyedUnarchiver unarchiveObjectWithData: data];
	//
	// FIXME: support dragging multiple items
	//
	NSUInteger destination = MIN(MAX(row, 0), _artboard.allStates.count-1);
	NSMutableArray *states = [_artboard.allStates mutableCopy];
	NSUInteger source = sourceIndexes.firstIndex;

	// 1) model updates
	id draggedState = [states objectAtIndex: source];
	[states removeObjectAtIndex: source];
	[states insertObject: draggedState atIndex: destination];
	[_artboard reorderStates: states];
	// 2) table view updates
	[tableView moveRowAtIndex: source toIndex: destination];

	return YES;
}
@end
