//
//  STTableCellView.h
//  States
//
//  Created by Dmitry Rodionov on 07/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
