// STStatefulArtboard+Snapshots.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STLayerState.h"
#import "NSArray+HigherOrder.h"
#import "STStatefulArtboard+Backend.h"
#import "STStatefulArtboard+Snapshots.h"

@implementation STStatefulArtboard (Snapshots)

- (id <STArtboard>)snapshotForState: (STStateDescription *)state
{
	NSParameterAssert([self.allStates containsObject: state]);

	id <STArtboard> snapshotInternal = [_internal copy];
	snapshotInternal.name = state.title;

	STStatefulArtboard *snapshot = [[STStatefulArtboard alloc] initWithArtboard: snapshotInternal
																		context: self.context];

	[snapshot applyState: state];
	[snapshot removeAllStates];

	return snapshotInternal;
}

@end
