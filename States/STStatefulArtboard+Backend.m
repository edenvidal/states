//
//  STStatefulArtboard+Backend.m
//  States
//
//  Created by Dmitry Rodionov on 04/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStatefulArtboard+Backend.h"

static NSString const *const kSTStatefulArtboardStatesKey       = @"x-statum-states";
static NSString const *const kSTStatefulArtboardStateValuesKey  = @"x-statum-state-values";
static NSString const *const kSTStatefulArtboardCurrentStateKey = @"x-statum-current-state";
static NSString const *const kSTStatefulArtboardDefaultStateKey = @"x-statum-default-state";

@implementation STStatefulArtboard (Backend)

- (NSArray <NSDictionary *> *)artboardStatesData
{
	return [[self.context command] valueForKey: kSTStatefulArtboardStatesKey onLayer: _internal] ?: @[];
}

- (void)setArtboardStatesData: (NSArray <NSDictionary *> *)newData
{
	[[self.context command] setValue: newData forKey: kSTStatefulArtboardStatesKey onLayer: _internal];
}

- (NSDictionary <NSString *, id> *)artboardCurrentStateData
{
	return [[self.context command] valueForKey: kSTStatefulArtboardCurrentStateKey onLayer: _internal] ?: @{};
}

- (void)setArtboardCurrentStateData: (NSDictionary <NSString *, id> *)newData
{
	[[self.context command] setValue: newData forKey: kSTStatefulArtboardCurrentStateKey onLayer: _internal];
}

- (NSDictionary <NSString *, id> *)metadataForLayer: (id <STLayer>)layer
{
	return [[self.context command] valueForKey: kSTStatefulArtboardStateValuesKey onLayer: layer] ?: @{};
}

- (void)setMedatada: (NSDictionary <NSString *, id> *)newMetadata forLayer: (id <STLayer>)layer
{
	[[self.context command] setValue: newMetadata forKey: kSTStatefulArtboardStateValuesKey onLayer: layer];
}

- (nonnull NSDictionary <NSString *, id> *)artboardDefaultStateData
{
	return [[self.context command] valueForKey: kSTStatefulArtboardDefaultStateKey onLayer: _internal] ?: @{};
}

- (void)setArtboardDefaultStateData: (nonnull NSDictionary <NSString *, id> *)newData
{
	[[self.context command] setValue: newData forKey: kSTStatefulArtboardDefaultStateKey onLayer: _internal];
}

@end
