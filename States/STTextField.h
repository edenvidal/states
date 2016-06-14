// STTextField.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


@import Cocoa;

@protocol STTextFieldFirstResponderDelegate <NSObject>
@optional
- (void)textFieldBecomeFirstResponder: (NSTextField *)textField;
@end

/// A text field that notifies its delegate that it has became firt responder
@interface STTextField : NSTextField

@property (weak) id <STTextFieldFirstResponderDelegate> firstResponderDelegate;

@end
