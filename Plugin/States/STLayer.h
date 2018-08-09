// STLayer.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;

@protocol STAbsoluteRect;

@protocol STLayer <NSObject>
@optional

- (BOOL)isVisible;
- (void)setIsVisible: (BOOL)visible;
- (id <STAbsoluteRect>)absoluteRect;

- (void)copyToLayer: (id <STLayer>)newParent beforeLayer: (id <STLayer>)sibling;

@end

@protocol STFrame <NSObject>
@optional

- (CGRect)rect;

- (CGFloat)x;
- (CGFloat)y;

- (void)setX: (CGFloat)x;
- (void)setY: (CGFloat)y;

@end

@protocol STAbsoluteRect <NSObject>
@optional

- (CGRect)absoluteRect;

- (void)setX: (CGFloat)x;
- (void)setY: (CGFloat)y;

@end
