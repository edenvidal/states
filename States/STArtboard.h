//
//  STArtboard.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;

@protocol STLayer;

@protocol STArtboard <NSObject, STLayer>
@optional

- (NSArray <id <STLayer>>*)children;

@end
