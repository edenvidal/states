// STPage.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;
#import "STArtboard.h"

@protocol STPage <NSObject, STLayer>
@optional

+ (instancetype)page;
- (instancetype)copy;

- (id <STArtboard>)currentArtboard;
- (NSArray *)artboards;

- (void)enumerateLayersWithOptions: (int)options block: (void(^)(id <STLayer> layer))block;

- (void)addLayers: (NSArray *)layers;
- (void)removeLayer: (id <STLayer>)layer;

- (void)selectLayers: (NSArray *)layers;

- (void)setName: (NSString *)name;
- (NSString *)name;

- (void)setPageDelegate: (id)pageDelegate;
- (id)pageDelegate;

- (void)setGrid: (id)grid;
- (id)grid;

- (void)setLayout: (id)layout;
- (id)layout;

- (void)setScrollOrigin: (id)scrollOrigin;
- (id)scrollOrigin;

- (void)setZoomValue: (CGFloat)zoomValue;
- (CGFloat)zoomValue;

@end
