// SketchPluginContext.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

#import "STSketchPluginContext.h"

@interface STSketchPluginContext()
@property (readwrite, strong) id pluginBundle;
@property (readwrite, strong) id <STDocument> document;
@property (readwrite, strong) id <STCommand> command;
@end

@implementation STSketchPluginContext

- (instancetype)initWithData: (NSDictionary *)data
{
	if ((self = [super init])) {
		_pluginBundle = data[@"plugin"];
		_document = data[@"document"];
		_command = data[@"command"];
	}
	return self;
}

@end
