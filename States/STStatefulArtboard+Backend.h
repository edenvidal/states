// STStatefulArtboard+Backend.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STStatefulArtboard.h"

/// STStatefulArtboard extension that allows to save data inside Sketch metadata
@interface STStatefulArtboard (Backend)

- (nonnull NSArray <NSDictionary *> *)artboardStatesData;
- (void)setArtboardStatesData: (nonnull NSArray <NSDictionary *> *)newData;

- (nonnull NSDictionary <NSString *, id> *)artboardCurrentStateData;
- (void)setArtboardCurrentStateData: (nonnull NSDictionary <NSString *, id> *)newData;

- (nonnull NSDictionary <NSString *, id> *)metadataForLayer: (nonnull id <STLayer>)layer;
- (void)setMedatada: (nonnull NSDictionary <NSString *, id> *)newMetadata forLayer: (nonnull id <STLayer>)layer;

- (nonnull NSDictionary <NSString *, id> *)artboardDefaultStateData;
- (void)setArtboardDefaultStateData: (nonnull NSDictionary <NSString *, id> *)newData;

@end
