// STTableCellView.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


#import "STColorFactory.h"
#import "STTableCellView.h"

@implementation STTableCellView

- (void)setBackgroundStyle: (NSBackgroundStyle)backgroundStyle
{
	[super setBackgroundStyle: backgroundStyle];

	if (backgroundStyle == NSBackgroundStyleLight) {
		self.textField.textColor = [STColorFactory tableViewCellTextRegularColor];
	} else {
		BOOL singleSelection = [self.delegate isSingleRowSelected];
		
		if (singleSelection || [self.delegate cellViewRepresentsCurrentItem: self]) {
			self.textField.textColor = [STColorFactory tableViewCellTextSelectedColorWithAlpha: 1.0f];
		} else {
			self.textField.textColor = [STColorFactory tableViewCellTextSelectedColorWithAlpha: 0.5f];
		}
	}
}

@end
