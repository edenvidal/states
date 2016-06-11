//
//  STPage.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;
#import "STArtboard.h"

@protocol STPage <NSObject>
@optional

- (id <STArtboard>)currentArtboard;

@end
