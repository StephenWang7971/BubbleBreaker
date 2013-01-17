//
//  OctScore.m
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import "OctScore.h"

@implementation OctScore

@synthesize current = _current;
@synthesize total = _tatal;
@synthesize accumulate = _accumulate;
@synthesize playCount = _playCount;
@synthesize selected = _selected;
@synthesize highest = _highest;


-(int) getAverage
{
    if (_playCount == 0) {
        return 0;
    }
    return _accumulate / _playCount;
}

-(void) clear
{
    _tatal = 0;
    _selected = 0;
}

@end
