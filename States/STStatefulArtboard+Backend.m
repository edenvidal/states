// STStatefulArtboard+Backend.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STStatefulArtboard+Backend.h"

static NSString const *const kSTStatefulArtboardStatesKey       = @"x-states-states";
static NSString const *const kSTStatefulArtboardStateValuesKey  = @"x-states-state-values";
static NSString const *const kSTStatefulArtboardCurrentStateKey = @"x-states-current-state";
static NSString const *const kSTStatefulArtboardDefaultStateKey = @"x-states-default-state";

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
