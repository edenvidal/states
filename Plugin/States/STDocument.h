// STDocument.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;
#import "STPage.h"

@protocol STDocumentData <NSObject>

- (void)addPage: (id <STPage>)page;
- (void)deselectAllLayers;

@end

@protocol STDocument <NSObject>
@optional

- (void)setCurrentPage: (id <STPage>)page;
- (id <STPage>)currentPage;

- (id)window;

- (id <STDocumentData>)documentData;

- (void)setSelectedLayers: (NSArray *)layers;

@end


