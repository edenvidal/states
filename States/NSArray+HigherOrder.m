//
//  NSArray+HigherOrder.m
//  States
//
//  Created by Dmitry Rodionov on 04/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "NSArray+HigherOrder.h"

@implementation NSArray (HigherOrder)

- (NSArray *)rd_map: (nonnull id _Nonnull (^)(id _Nonnull obj))mapper
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity: self.count];
	[self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[result addObject: mapper(obj)];
	}];
	return result;
}

- (NSArray *)rd_filter: (BOOL (^)(id))block
{
	NSMutableArray *new = [NSMutableArray array];
	[self enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		if (block(obj)) [new addObject: obj];
	}];
	return new;
}

@end
