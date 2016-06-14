// NSArray+Indexes.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;

@interface NSArray (Indexes)

- (nonnull NSIndexSet *)rd_indexesOfObjects: (nonnull NSArray *)subarray;

@end
