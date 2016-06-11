//
//  STTextField.m
//  States
//
//  Created by Dmitry Rodionov on 11/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STTextField.h"

@implementation STTextField

- (BOOL)becomeFirstResponder
{
	BOOL result = [super becomeFirstResponder];
	if (result && [self.delegate respondsToSelector: @selector(textFieldBecomeFirstResponder:)]) {
		[self.firstResponderDelegate textFieldBecomeFirstResponder: self];
	}
	return result;
}
@end
