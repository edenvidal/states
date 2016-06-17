// STStatefulArtboard+Snapshots.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STStatefulArtboard.h"

@interface STStatefulArtboard (Snapshots)

/// Returns a new artboard reflecting the given state. All states metadata will be lost (i.e. it
/// will be "clean" snapshot)
- (id <STArtboard>)snapshotForState: (STStateDescription *)state;

@end
