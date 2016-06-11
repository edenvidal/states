//
//  STTableCellView.h
//  States
//
//  Created by Dmitry Rodionov on 07/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

#import "STUpdateButton.h"

@interface STTableCellView : NSTableCellView

@property (weak) IBOutlet STUpdateButton *updateButton;

@end
