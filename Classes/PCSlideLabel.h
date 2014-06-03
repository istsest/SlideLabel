//
//  PCSlideLabel.h
//
//  Created by Joon on 6/2/14.
//  Copyright (c) 2014 Joon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCSlideLabel : UILabel

@property BOOL autoDetectAndStart;
@property int delaySeconds;

@property float updateTime;
@property float shiftPixcel;

- (void)startWithDelay:(int)delay;
- (void)pause;
- (void)stop;

- (BOOL)isOverflow;

@end
