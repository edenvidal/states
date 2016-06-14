// NSArray+HigherOrder.m
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.


#import "NSArray+HigherOrder.h"

@implementation NSArray (HigherOrder)

- (NSArray *)st_map: (nonnull id _Nonnull (^)(id _Nonnull obj))mapper
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity: self.count];
	[self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[result addObject: mapper(obj)];
	}];
	return result;
}

- (NSArray *)st_filter: (BOOL (^)(id))block
{
	NSMutableArray *new = [NSMutableArray array];
	[self enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		if (block(obj)) [new addObject: obj];
	}];
	return new;
}

@end
