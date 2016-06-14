// STPage.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;
#import "STArtboard.h"

@protocol STPage <NSObject>
@optional

- (id <STArtboard>)currentArtboard;

@end
