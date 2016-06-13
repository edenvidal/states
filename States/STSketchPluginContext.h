//
//  SketchPluginContext.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

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
