//
//  STTextField.m
//  States
//
//  Created by Dmitry Rodionov on 11/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
