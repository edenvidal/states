//
//  STUpdateButton.h
//  States
//
//  Created by Dmitry Rodionov on 09/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

typedef void(^STUpdateButtonAnimationCompletion)(void);

@interface STUpdateButton : NSButton

- (void)spinWithCompletion: (STUpdateButtonAnimationCompletion)completion;

@end
