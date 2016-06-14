// NSArray+HigherOrder.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;

@interface NSArray (HigherOrder)

- (nonnull NSArray *)rd_map: (nonnull id _Nonnull (^)(id _Nonnull obj))mapper;

- (nonnull NSArray *)rd_filter: (nonnull BOOL (^)(id _Nonnull obj))block;

@end
