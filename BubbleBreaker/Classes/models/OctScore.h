//
//  OctScore.h
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OctScore : NSObject

@property (readwrite) int current;
@property (readwrite) int total;
@property (readwrite) int accumulate;
@property (readwrite) int playCount;
@property (readwrite) int selected;
@property (readwrite) int highest;


-(int) getAverage;
-(void) clear;

@end
