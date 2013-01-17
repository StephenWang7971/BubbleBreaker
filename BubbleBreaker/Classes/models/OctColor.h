//
//  OctColor.h
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OctColor : NSObject 

@property int color;
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) UIImage * image;
@property (retain, nonatomic) UIImage * selected;

-(void) setColor:(int) c;
@end
