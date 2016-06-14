//
//  Sketch.m
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//
#import <objc/runtime.h>
#import "Aspects.h"
#import "STSketch.h"
#import "STStatefulArtboard.h"

@interface STSketch()
@property (strong) NSHashTable *listeners;
@end

@implementation STSketch

+ (instancetype)notificationObserver
{
	static STSketch *observer = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		observer = [STSketch new];
		observer.listeners = [NSHashTable weakObjectsHashTable];
		[observer injectIntoMSDocument];
	});
	return observer;
}

- (void)addListener: (id)listener
{
	[_listeners addObject: listener];
}

#pragma mark -

+ (id <STDocument>)currentDocument
{
	return [NSClassFromString(@"MSDocument") currentDocument];
}

+ (id <STPage>)currentPage
{
	return [[self currentDocument] currentPage];
}

+ (id <STArtboard>)currentArtboard
{
	id <STArtboard> raw = [[self currentPage] currentArtboard];
	if (!raw) {
		return nil;
	}
	return [[STStatefulArtboard alloc] initWithArtboard: raw context: [self pluginContext]];
}

#pragma mark -

+ (void)setPluginContextDictionary: (NSDictionary *)contextDictionary;
{
	STSketchPluginContext *context = [[STSketchPluginContext alloc] initWithData: contextDictionary];
	objc_setAssociatedObject(self, @selector(pluginContext), context, OBJC_ASSOCIATION_RETAIN);
}

+ (instancetype)pluginContext
{
	id context = objc_getAssociatedObject(self, @selector(pluginContext));
	NSAssert(context != nil, @"You must set pluginContext via [%@ setPluginContext:] method before calling any other methods of this class", [self class]);
	return context;
}

#pragma mark -

/// Inject ourselves into Sketch internals to receive notifications about artboard selection
/// and document changes
- (void)injectIntoMSDocument
{
	Class MSDocument = NSClassFromString(@"MSDocument");
	Class _MSLayer = NSClassFromString(@"_MSLayer");
	Class MSPage = NSClassFromString(@"MSPage");
	Class _MSImmutableLayer = NSClassFromString(@"_MSImmutableLayer");

	[[NSNotificationCenter defaultCenter] addObserverForName: NSWindowWillCloseNotification
													  object: [[STSketch currentDocument] window]
													   queue: [NSOperationQueue mainQueue]
												  usingBlock: ^(NSNotification * _Nonnull note)
	 {
		 for (id <SketchNotificationsListener> listener in [_listeners allObjects]) {
			 [listener currentArtboardUnselected];
		 }
	}];

	SEL currentArtboardDidChangeSelector = NSSelectorFromString(@"currentArtboardDidChange");
	[MSDocument aspect_hookSelector: currentArtboardDidChangeSelector withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 NSAssert(aspectInfo.instance == [STSketch currentDocument],
				  @"Unexpected artboard selection update from a secondary document");
		 for (id <SketchNotificationsListener> listener in [_listeners allObjects]) {
			 [listener currentArtboardDidChange];
		 }
	 } error: NULL];

	[MSDocument aspect_hookSelector: @selector(windowDidBecomeKey:) withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 // Wait until the next run loop iteration to let Sketch switch to a new document
		 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			 for (id <SketchNotificationsListener> listener in [_listeners allObjects]) {
				 [listener currentArtboardDidChange];
			 }
		 });
	 } error: NULL];

	/// XXX
	SEL setCurrentArtboard = NSSelectorFromString(@"setCurrentArtboard:");
	[MSPage aspect_hookSelector: setCurrentArtboard withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 id artboard = [[aspectInfo arguments] firstObject];
		 for (id <SketchNotificationsListener> listener in [_listeners allObjects]) {
			 if (!artboard) {
				 [listener currentArtboardUnselected];
			 } else {
				 [listener currentArtboardDidChange];
			 }
		 }
	 } error: NULL];

	Class MSDocumentData = NSClassFromString(@"MSDocumentData");
	SEL changeSelectionTo = NSSelectorFromString(@"changeSelectionTo:");
	[MSDocumentData aspect_hookSelector: changeSelectionTo withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 NSArray *selection = [[aspectInfo arguments] firstObject];
		 if (![selection isKindOfClass: [NSArray class]]) {
			 return;
		 }
		 for (id <SketchNotificationsListener> listener in [_listeners allObjects]) {
			 if (selection.count != 0) {
				[listener currentArtboardDidChange];
			 }
		 }
	 } error: NULL];


	/// XXX
	void (^documentUpdateHandler)(void) = ^(void) {
		for (id <SketchNotificationsListener> listener in [_listeners allObjects]) {
			[listener currentDocumentUpdated];
		}
	};

	// XXX
	SEL layerPositionPossiblyChanged = NSSelectorFromString(@"layerPositionPossiblyChanged");
	[MSDocument aspect_hookSelector: layerPositionPossiblyChanged withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 id <STDocument> doc = aspectInfo.instance;
		 if ([[doc currentPage] currentArtboard] == [[STSketch currentPage] currentArtboard]) {
			 documentUpdateHandler();
		 }
	 } error: NULL];

	// XXX
	[MSDocument aspect_hookSelector: NSSelectorFromString(@"undoAction:") withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 id <STDocument> doc = aspectInfo.instance;
		 if ([[doc currentPage] currentArtboard] == [[STSketch currentPage] currentArtboard]) {
			 documentUpdateHandler();
		 }
	 } error: NULL];

	/// XXX
	SEL setIsVisible = NSSelectorFromString(@"setIsVisible:");
	[_MSImmutableLayer aspect_hookSelector: setIsVisible withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 documentUpdateHandler();
	 } error: NULL];

	[_MSLayer aspect_hookSelector: setIsVisible withOptions: AspectPositionAfter usingBlock: ^(id<AspectInfo> aspectInfo)
	 {
		 documentUpdateHandler();
	 } error: NULL];
}

@end
