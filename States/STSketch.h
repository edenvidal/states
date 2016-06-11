//
//  Sketch.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;
#import "STStateDescription.h"
#import "STDocument.h"
#import "STSketchPluginContext.h"

@protocol SketchNotificationsListener <NSObject>
@required
- (void)currentArtboardDidChange;
- (void)currentArtboardUnselected;
- (void)currentDocumentUpdated;
@end

@interface STSketch : NSObject

/// XXX
+ (id <STDocument>)currentDocument;
+ (id <STPage>)currentPage;
+ (id <STArtboard>)currentArtboard;

/// XXX
+ (instancetype)notificationObserver;
- (void)addListener: (id <SketchNotificationsListener>)listener;

/// XXX
+ (void)setPluginContextDictionary: (NSDictionary *)contextDictionary;
+ (STSketchPluginContext *)pluginContext;

@end
