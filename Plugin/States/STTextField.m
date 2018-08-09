// STTextField.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STColorFactory.h"
#import "STTextField.h"

@implementation STTextField

- (BOOL)becomeFirstResponder
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.textColor = [STColorFactory tableViewCellTextRegularColor];
	});

	BOOL result = [super becomeFirstResponder];
	if (result && [self.delegate respondsToSelector: @selector(textFieldBecomeFirstResponder:)]) {
		[self.firstResponderDelegate textFieldBecomeFirstResponder: self];
	}
	return result;
}

@end
