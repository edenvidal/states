// STDocument.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;
#import "STPage.h"

@protocol STDocument <NSObject>
@optional

- (id <STPage>)currentPage;
- (id)window;

@end
