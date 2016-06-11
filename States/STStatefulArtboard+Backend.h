//
//  STStatefulArtboard+Backend.h
//  States
//
//  Created by Dmitry Rodionov on 04/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStatefulArtboard.h"

/// XXX
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
