//
//  OctColor.m
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import "OctColor.h"

@implementation OctColor

@synthesize color = _color;
@synthesize name = _name;
@synthesize image = _image;
@synthesize selected = _selected;

-(void)setColor:(int)c {
    
    NSArray * colors = [[NSArray alloc] initWithObjects:@"red", @"green", @"blue", @"yellow", @"gray", @"coffee", nil ];
    
    _color = c;
    _name = colors[c];
    _image = [UIImage imageNamed: [colors[c] stringByAppendingString:@".png" ]];
    _selected = [UIImage imageNamed:[colors[c] stringByAppendingString:@"-light.png" ]];
}

@end
