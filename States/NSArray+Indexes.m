// NSArray+Indexes.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "NSArray+Indexes.h"

@implementation NSArray (Indexes)

- (nonnull NSIndexSet *)rd_indexesOfObjects: (nonnull NSArray *)subarray
{
	return [self indexesOfObjectsPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL * stop) {
		return [subarray containsObject: obj];
	}];
}

@end
