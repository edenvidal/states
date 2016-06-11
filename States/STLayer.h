//
//  STLayer.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;

@protocol STLayer <NSObject>
@optional

- (BOOL)isVisible;
- (void)setIsVisible: (BOOL)visible;
- (id)absoluteRect;
@end

@protocol STFrame <NSObject>
@optional

- (CGRect)rect;

- (CGFloat)x;
- (CGFloat)y;

- (void)setX: (CGFloat)x;
- (void)setY: (CGFloat)y;

@end
