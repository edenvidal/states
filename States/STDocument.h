//
//  STDocument.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;
#import "STPage.h"

@protocol STDocument <NSObject>
@optional

- (id <STPage>)currentPage;
- (id)window;

@end
