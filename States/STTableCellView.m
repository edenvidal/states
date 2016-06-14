//
//  STTableCellView.m
//  States
//
//  Created by Dmitry Rodionov on 07/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
