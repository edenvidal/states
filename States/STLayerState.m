//
//  State.m
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STLayer.h"
#import "STLayerState.h"

@implementation STLayerState

- (instancetype)initWithFrame: (NSRect)aFrame visibilityStatus: (BOOL)visible
{
	if ((self = [super init])) {
		_frame = aFrame;
		_visible = visible;
	}
	return self;
}

+ (instancetype)stateWithFrame: (NSRect)aFrame visibilityStatus: (BOOL)visible
{
	return [[[self class] alloc] initWithFrame: aFrame visibilityStatus: visible];
}

- (NSDictionary <NSString *, id> *)dictionaryRepresentation
{
	return @{
		@"frame" : NSStringFromRect(_frame),
		@"visible" : @(_visible)
	};
}

- (instancetype)initWithDictionary: (NSDictionary <NSString *, id> *)dictionary
{
	NSParameterAssert(dictionary[@"frame"]);
	NSParameterAssert(dictionary[@"visible"]);

	return [self initWithFrame: NSRectFromString(dictionary[@"frame"])
			  visibilityStatus: [dictionary[@"visible"] boolValue]];
}

- (BOOL)isEqual: (id)object
{
	typeof(self) another = object;

	if (![another isKindOfClass: [self class]]) {
		return NO;
	}
	if (!NSEqualRects(_frame, another.frame)) {
		return NO;
	}
	if (_visible != another.visible) {
		return NO;
	}
	return YES;
}

- (NSUInteger)hash
{
	return NSStringFromRect(_frame).hash + @(_visible).hash;
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"<%@: %p> (frame = %@, visible = %@)",
			NSStringFromClass([self class]), (void *)self,
			NSStringFromRect(_frame), _visible ? @"YES" : @"NO"];
}

@end

@implementation STLayerStateApplier

+ (void)apply: (STLayerState *)state toLayer: (id <STLayer>)layer
{
	layer.isVisible = state.visible;

	id <STFrame> frame = [layer performSelector: @selector(frame)];
	frame.x = state.frame.origin.x;
	frame.y = state.frame.origin.y;
}

@end

@implementation STLayerStateFetcher : NSObject

+ (STLayerState *)fetchStateFromLayer: (id <STLayer>)layer
{
	id <STFrame> frameObject = [layer performSelector: @selector(frame)];
	return [[STLayerState alloc] initWithFrame: NSRectFromCGRect(frameObject.rect)
							  visibilityStatus: layer.isVisible];
}

@end

@implementation STLayerStateExaminer : NSObject

+ (BOOL)layer: (id <STLayer>)layer conformsToState: (STLayerState *)state
{
	id <STFrame> frameObject = [layer performSelector: @selector(frame)];
	NSRect layerRect = NSRectFromCGRect(frameObject.rect);

	if (layer.isVisible != state.visible) {
		return NO;
	}
	if (!NSEqualPoints(layerRect.origin, state.frame.origin)) {
		return NO;
	}
	return YES;
}

@end
