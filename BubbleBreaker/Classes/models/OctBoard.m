//
//  OctBoard.m
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import "OctBoard.h"

//TODO do not duplicate it.
#define MAX_ROW 10
#define MAX_COLUMN 10

@implementation OctBoard


@synthesize bubbles = _bubbles;

-(id)init
{
    
	self=[super init];
	if(self){
        _bubbles = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)shuffle
{
    [_bubbles removeAllObjects];
    for (int i = 0;i < MAX_ROW; i++)
    {
        for(int j = 0; j < MAX_COLUMN; j++)
        {
            int color = arc4random() % 5;
            OctBubble *bubble = [[ OctBubble alloc]init];
            bubble.x = j;
            bubble.y = i;
            bubble.selected = NO;
            bubble.destroyed = NO;
            //TODO get color from NSDictionary, to reduce memory use.
            bubble.color = [[ OctColor alloc] init];            
            [bubble.color setColor:color];
            
            [_bubbles addObject:bubble];
        }
    }
}


@end
