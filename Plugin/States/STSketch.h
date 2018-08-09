// STSketch.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

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

/// Toggles the plugin's menu item's titles between "Show States" and "Hide States"
+ (void)toggleStatesPluginName;

@end
