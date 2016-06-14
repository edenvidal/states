//
//  NSArray+Indexes.m
//  States
//
//  Created by Dmitry Rodionov on 13/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "NSArray+Indexes.h"

@implementation NSArray (Indexes)

- (nonnull NSIndexSet *)rd_indexesOfObjects: (nonnull NSArray *)subarray
{
	return [self indexesOfObjectsPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL * stop) {
		return [subarray containsObject: obj];
	}];
}

@end
