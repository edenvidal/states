//
//  NSArray+Indexes.h
//  States
//
//  Created by Dmitry Rodionov on 13/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;

@interface NSArray (Indexes)

- (nonnull NSIndexSet *)rd_indexesOfObjects: (nonnull NSArray *)subarray;

@end
