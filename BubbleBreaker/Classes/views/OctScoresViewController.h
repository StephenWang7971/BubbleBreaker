//
//  OctSecondViewController.h
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OctScoresViewController : UIViewController

@property (nonatomic, retain) UILabel* highest;
@property (nonatomic, retain) UILabel* average;
@property (nonatomic, retain) UILabel* playCount;


- (IBAction)clearScore:(id)sender;

- (void) displayScore;

@end
