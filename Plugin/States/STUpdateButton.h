// STUpdateButton.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

@import Cocoa;

typedef void (^STUpdateButtonAnimationCompletion)(void);

/// A simple button that may rotate its image clockwise
@interface STUpdateButton : NSButton

- (void)spinWithCompletion: (STUpdateButtonAnimationCompletion)completion;

@end
