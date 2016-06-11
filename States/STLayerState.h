//
//  State.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;

@protocol STLayer;

/// XXX
@interface STLayerState : NSObject

@property (readonly) NSRect frame;
@property (readonly) BOOL visible;

- (instancetype)initWithFrame: (NSRect)aFrame visibilityStatus: (BOOL)visible;
+ (instancetype)stateWithFrame: (NSRect)aFrame visibilityStatus: (BOOL)visible;

- (NSDictionary <NSString *, id> *)dictionaryRepresentation;
- (instancetype)initWithDictionary: (NSDictionary <NSString *, id> *)dictionary;

@end

/// XXX
@interface STLayerStateApplier : NSObject
+ (void)apply: (STLayerState *)state toLayer: (id <STLayer>)layer;
@end

/// XXX
@interface STLayerStateFetcher : NSObject
+ (STLayerState *)fetchStateFromLayer: (id <STLayer>)layer;
@end

/// XXX
@interface STLayerStateExaminer : NSObject
+ (BOOL)layer: (id <STLayer>)layer conformsToState: (STLayerState *)state;
@end
