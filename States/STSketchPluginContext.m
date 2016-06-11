//
//  SketchPluginContext.m
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
