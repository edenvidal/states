// STTableCellView.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


@import Cocoa;

#import "STUpdateButton.h"

@class STTableCellView;

@protocol STTableCellViewDelegate <NSObject>
@required
- (BOOL)cellViewRepresentsCurrentItem: (STTableCellView *)cellView;
- (BOOL)isSingleRowSelected;
@end

/// A cell view that sets custom text field colors depending on whether it represents the current
/// state model or not
@interface STTableCellView : NSTableCellView

@property (weak) id <STTableCellViewDelegate> delegate;
@property (weak) IBOutlet STUpdateButton *updateButton;

@end
