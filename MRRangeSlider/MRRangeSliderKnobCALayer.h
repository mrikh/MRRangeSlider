//
//  MRRangeSliderShapeLayer.h
//  MRRangeSlider
//
//  Created by Mayank Rikh on 14/12/16.
//  Copyright © 2016 Mayank Rikh. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class MRRangeSlider;

@interface MRRangeSliderKnobCALayer : CALayer

@property BOOL highlighted;

@property (weak) MRRangeSlider* slider;

@end
