// SketchPluginContext.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Foundation;
#import "STDocument.h"
#import "STCommand.h"

/// Encapsulate a Sketch plugin context dictionary
@interface STSketchPluginContext : NSObject

@property (readonly, strong) id pluginBundle;
@property (readonly, strong) id <STDocument> document;
@property (readonly, strong) id <STCommand> command;

- (instancetype)initWithData: (NSDictionary *)data;

@end
