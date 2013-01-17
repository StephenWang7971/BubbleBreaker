//
//  OctBubble.h
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OctColor.h"

@interface OctBubble : NSObject

@property (readwrite) int x;
@property (readwrite) int y;
@property (nonatomic, retain) OctColor* color;
@property (readwrite) bool selected;
@property (readwrite) bool destroyed;

@end
