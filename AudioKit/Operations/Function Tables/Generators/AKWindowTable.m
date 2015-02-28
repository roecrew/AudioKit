//
//  AKWindowTable.m
//  AudioKit
//
//  Created by Aurelius Prochazka on 1/27/15.
//  Copyright (c) 2015 AudioKit. All rights reserved.
//

#import "AKWindowTable.h"

@interface AKWindowTable()
@property AKWindowTableType windowType;
@end

@implementation AKWindowTable

- (instancetype)initWithType:(AKWindowTableType)windowType
{
    self = [super initWithType:AKFunctionTableTypeWindow];
    if (self) {
        self.windowType = windowType;
        self.size = 4096;
        self.maximum = 1.0;
        self.standardDeviation = 1.0;
        self.kaiserOpenness = 1.0;
    }
    return self;
}

- (void)setOptionalMaximum:(float)maximum {
    self.maximum = maximum;
}

- (void)setOptionalKaiserWindowOpenness:(float)kaiserOpenness {
    _kaiserOpenness = kaiserOpenness;
}

- (void)setOptionalGaussianWindowStandardDeviation:(float)standardDeviation {
    _standardDeviation = standardDeviation;
}

- (NSString *)stringForCSD
{
    float modifier = self.standardDeviation;
    if (self.windowType == AKWindowTableTypeKaiser) modifier = self.kaiserOpenness;
    
    return [NSString stringWithFormat:@"%@ ftgen %d, 0, %d, -%lu, %d, %f, %f",
            self,
            [self number],
            self.size,
            (unsigned long)AKFunctionTableTypeWindow,
            (int)self.windowType,
            self.maximum,
            modifier];
}



@end