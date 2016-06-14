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

/// The bridge between Sketch and our plugin. Provides info about current document as well
/// as various notifications available for SketchNotificationsListener
@interface STSketch : NSObject

/// Information about the curent document: the document itself, current page and artboard
+ (id <STDocument>)currentDocument;
+ (id <STPage>)currentPage;
+ (id <STArtboard>)currentArtboard;

/// Use this observer to subscribe to various Sketch notifications. See SketchNotificationsListener
/// for more details
+ (instancetype)notificationObserver;
- (void)addListener: (id <SketchNotificationsListener>)listener;

/// We must save a plugin context in order to perform some layer modifications (i.e. use plugin command)
/// IMPORTANT: You must set this context via -setPluginContext: method before calling any other methods
/// of this class.
+ (void)setPluginContextDictionary: (NSDictionary *)contextDictionary;
+ (STSketchPluginContext *)pluginContext;

@end
