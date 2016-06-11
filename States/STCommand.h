//
//  STCommand.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;
#import "STLayer.h"

@protocol STCommand <NSObject>
@optional

- (void)setValue: (id)value forKey: (id <NSCopying>)key onLayer:(id <STLayer>)layer;
- (id)valueForKey:(id <NSCopying>)key onLayer:(id <STLayer>)layer;

@end
