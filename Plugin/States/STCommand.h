// STCommand.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


@import Foundation;
#import "STLayer.h"

@protocol STCommand <NSObject>
@optional

- (void)setValue: (id)value forKey: (id <NSCopying>)key onLayer: (id <STLayer>)layer;
- (id)valueForKey: (id <NSCopying>)key onLayer: (id <STLayer>)layer;

@end
