// STArtboard.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;

@protocol STLayer;

@protocol STArtboard <NSObject, STLayer>
@optional

- (NSArray <id <STLayer>>*)children;

@end
