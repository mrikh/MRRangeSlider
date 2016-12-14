//
//  MRRangeSlider.m
//  MRRangeSlider
//
//  Created by Mayank Rikh on 14/12/16.
//  Copyright © 2016 Mayank Rikh. All rights reserved.
//

#import "MRRangeSliderKnobCALayer.h"
#import "MRRangeSlider.h"

@interface MRRangeSlider(){
    
    CALayer* trackLayer;
    MRRangeSliderKnobCALayer* upperKnobLayer;
    MRRangeSliderKnobCALayer* lowerKnobLayer;
    
    float knobWidth;
    float useableTrackLength;
    
    CGPoint previousTouchPoint;
}

@end

@implementation MRRangeSlider

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor redColor]];
    
    self.maximumValue = 10.0;
    
    self.minimumValue = 0.0;
    
    self.upperValue = 8.0;
    
    self.lowerValue = 2.0;
    
    trackLayer = [CALayer layer];
    
    trackLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    [self.layer addSublayer:trackLayer];
    
    upperKnobLayer = [MRRangeSliderKnobCALayer layer];
    
    upperKnobLayer.slider = self;
    
    upperKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
    
    [self.layer addSublayer:upperKnobLayer];
    
    lowerKnobLayer = [MRRangeSliderKnobCALayer layer];
    
    lowerKnobLayer.slider = self;
    
    lowerKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
    
    [self.layer addSublayer:lowerKnobLayer];
}

-(void)layoutSubviews{
    
    [self setLayerFrames];
}

- (void)setLayerFrames
{
    trackLayer.frame = CGRectInset(self.bounds, 0, self.bounds.size.height / 3.5);
    
    [trackLayer setNeedsDisplay];
    
    knobWidth = self.bounds.size.height;
    
    useableTrackLength = self.bounds.size.width - knobWidth;
    
    float upperKnobCentre = [self positionForValue:self.upperValue];
    
    upperKnobLayer.frame = CGRectMake(upperKnobCentre - knobWidth / 2, 0, knobWidth, knobWidth);
    
    float lowerKnobCentre = [self positionForValue:self.lowerValue];
    
    lowerKnobLayer.frame = CGRectMake(lowerKnobCentre - knobWidth / 2, 0, knobWidth, knobWidth);
    
    [upperKnobLayer setNeedsDisplay];
    
    [lowerKnobLayer setNeedsDisplay];
}

- (float) positionForValue:(float)value
{
    return useableTrackLength * (value - _minimumValue) /
    (_maximumValue - _minimumValue) + (knobWidth / 2);
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    previousTouchPoint = [touch locationInView:self];
    
    if(CGRectContainsPoint(lowerKnobLayer.frame, previousTouchPoint)){
        
        lowerKnobLayer.highlighted = YES;
        
        [lowerKnobLayer setNeedsDisplay];
        
    }else if(CGRectContainsPoint(upperKnobLayer.frame, previousTouchPoint)){
        
        upperKnobLayer.highlighted = YES;
        
        [upperKnobLayer setNeedsDisplay];
    }
    
    return upperKnobLayer.highlighted || lowerKnobLayer.highlighted;
}

#define BOUND(VALUE, UPPER, LOWER)	MIN(MAX(VALUE, LOWER), UPPER)

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    // 1. determine by how much the user has dragged
    float delta = touchPoint.x - previousTouchPoint.x;
    float valueDelta = (_maximumValue - _minimumValue) * delta / useableTrackLength;
    
    previousTouchPoint = touchPoint;
    
    // 2. update the values
    if (lowerKnobLayer.highlighted)
    {
        _lowerValue += valueDelta;
        _lowerValue = BOUND(_lowerValue, _upperValue, _minimumValue);
    }
    if (upperKnobLayer.highlighted)
    {
        _upperValue += valueDelta;
        _upperValue = BOUND(_upperValue, _maximumValue, _lowerValue);
    }
    
    // 3. Update the UI state
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    
    [self setLayerFrames];
    
    [CATransaction commit];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    lowerKnobLayer.highlighted = upperKnobLayer.highlighted = NO;
    [lowerKnobLayer setNeedsDisplay];
    [upperKnobLayer setNeedsDisplay];
}

@end
