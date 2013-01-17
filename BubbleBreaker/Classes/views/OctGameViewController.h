//
//  OctFirstViewController.h
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OctGame.h"
#import "OctBubble.h"

@interface OctGameViewController : UIViewController 
- (IBAction)regretOneStep:(id)sender;

@property (nonatomic, retain) NSMutableArray * bubbles;
@property (nonatomic, retain) UILabel * score;
@property (nonatomic, retain) UILabel * selected;



- (IBAction)startGame:(id)sender;

- (void) render:(BOOL)fallen:(int)minSelectedIndex;

- (void) handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;

- (void) gameOver;

@end
