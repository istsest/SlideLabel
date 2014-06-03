//
//  PCSlideLabel.m
//
//  Created by Joon on 6/2/14.
//  Copyright (c) 2014 Joon. All rights reserved.
//

#import "PCSlideLabel.h"

@interface PCSlideLabel ()
{
	NSTimer *_updateTimer;
	CGFloat _offset;
	CGFloat _fullWidth;
	
	float _updateTime;
}

@end

@implementation PCSlideLabel


- (void)startWithDelay:(int)delay
{
	if(_updateTimer)
		return;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		sleep(delay);
		_updateTimer = [NSTimer timerWithTimeInterval:_updateTime target:self selector:@selector(updateSlide:) userInfo:nil repeats:YES];
		NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
		[runLoop addTimer:_updateTimer forMode:NSDefaultRunLoopMode];
	});
}

- (void)pause
{
	[_updateTimer invalidate];
	_updateTimer = nil;
}

- (void)stop
{
	[self pause];
	_offset = 0;
	[self setNeedsDisplay];
}

- (BOOL)isOverflow
{
	return _fullWidth > self.bounds.size.width;
}

- (float)updateTime
{
	return _updateTime;
}

- (void)setUpdateTime:(float)updateTime
{
	_updateTime = updateTime;
	[self pause];
	[self startWithDelay:self.delaySeconds];
}

- (void)updateSlide:(NSTimer *)timer
{
	_offset -= self.shiftPixcel;
	[self setNeedsDisplay];
}

- (CGFloat)widthText
{
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
	CGSize size = [self.text sizeWithAttributes:attributes];
	return size.width;
}

- (CGFloat)absoluteX:(CGFloat)rx
{
	if(self.textAlignment == NSTextAlignmentRight)
		return self.bounds.size.width - _fullWidth + rx;
	else if(self.textAlignment == NSTextAlignmentCenter && _fullWidth <= self.bounds.size.width)
		return ((self.bounds.size.width - _fullWidth) / 2) + rx;
	return rx;
}

- (void)setText:(NSString *)text
{
	[self stop];
	[super setText:text];
	_fullWidth = [self widthText];
	if(self.autoDetectAndStart && [self isOverflow])
		[self startWithDelay:self.delaySeconds];
}

- (void)initSlide
{
	_autoDetectAndStart = YES;
	_delaySeconds = 2;
	_updateTime = 0.02;
	_shiftPixcel = 1.0;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self initSlide];
		_fullWidth = [self widthText];
		if(self.autoDetectAndStart && [self isOverflow])
			[self startWithDelay:self.delaySeconds];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initSlide];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	rect.origin.x += _offset;
	if(_fullWidth > rect.size.width)
		rect.size.width = _fullWidth;
	[self drawTextInRect:rect];

	CGFloat x = [self absoluteX:_offset];
	if(x + _fullWidth < self.bounds.size.width / 2)
	{
		rect.origin.x = [self absoluteX:self.bounds.size.width] - (self.bounds.size.width / 2 - (x + _fullWidth));
		[self drawTextInRect:rect];
	}

	if(x + _fullWidth < -10)
		_offset = rect.origin.x;
}

@end
