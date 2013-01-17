//
//  OctBoard.h
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OctBubble.h"



@interface OctBoard : NSObject

@property (nonatomic, retain) NSMutableArray * bubbles;

-(void) shuffle;

@end
