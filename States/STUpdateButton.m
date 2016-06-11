//
//  STUpdateButton.m
//  States
//
//  Created by Dmitry Rodionov on 09/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import QuartzCore;

#import "STUpdateButton.h"

@interface STUpdateButton()
{
	STUpdateButtonAnimationCompletion _completion;
}
@end

@implementation STUpdateButton

- (instancetype)init
{
	if ((self = [super init])) {
		self.wantsLayer = YES;
	}
	return self;
}


- (void)spinWithCompletion: (STUpdateButtonAnimationCompletion)completion
{
	if (!CGPointEqualToPoint(self.layer.anchorPoint, CGPointMake(0.5, 0.5))) {
		[self fixAnchorPoint];
	}
	// Rotate 360° clockwise
	CABasicAnimation *spinningAnimation = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
	spinningAnimation.fromValue = @(0.0f);
	spinningAnimation.toValue = @(-2 * M_PI);
	spinningAnimation.duration = 0.5f;
	spinningAnimation.delegate = self;
	_completion = (__bridge STUpdateButtonAnimationCompletion)(_Block_copy((__bridge const void *)(completion)));
	[self.layer addAnimation: spinningAnimation forKey: nil];
}

- (void)animationDidStop: (CAAnimation *)animation finished: (BOOL)flag
{
	if (_completion) {
		_completion();
		_Block_release((__bridge const void *)(_completion));
	}
}

- (void)fixAnchorPoint
{
	CGRect frame = self.layer.frame;
	CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
	self.layer.position = center;
	self.layer.anchorPoint = CGPointMake(0.5, 0.5);
}

@end
