//
//  STTextField.h
//  States
//
//  Created by Dmitry Rodionov on 11/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

@protocol STTextFieldFirstResponderDelegate <NSObject>
@optional
- (void)textFieldBecomeFirstResponder: (NSTextField *)textField;
@end

/// XXX
@interface STTextField : NSTextField

@property (weak) id <STTextFieldFirstResponderDelegate> firstResponderDelegate;

@end
