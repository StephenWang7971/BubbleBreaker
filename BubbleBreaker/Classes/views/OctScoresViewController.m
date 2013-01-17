//
//  OctSecondViewController.m
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import "OctScoresViewController.h"
#import "OctGame.h"

@interface OctScoresViewController ()

@end

@implementation OctScoresViewController

@synthesize highest =_highest;
@synthesize average =_average;
@synthesize playCount = _playCount;


- (void)viewDidLoad
{
    [super viewDidLoad];
	    
    _highest = [[UILabel alloc]init];
    [[self view] addSubview:_highest];
    
    CGRect newFrame = CGRectMake(140, 38, 50, 15);
    [_highest setFrame:newFrame];


    _average = [[UILabel alloc]init];
    [[self view] addSubview:_average];
    
    newFrame = CGRectMake(140, 94, 50, 15);
    [_average setFrame:newFrame];


    _playCount = [[UILabel alloc]init];
    [[self view] addSubview:_playCount];
    
    newFrame = CGRectMake(140, 152, 50, 15);
    [_playCount setFrame:newFrame];
    
    [self displayScore];
}

- (IBAction)clearScore:(id)sender {
    NSLog(@"clear score");
}

- (void) displayScore {
    OctGame *game = [OctGame getInstance];
    int h = game.score.highest;
    int a = [game.score getAverage];
    int c = game.score.playCount;
    
    [_highest setText:[NSString stringWithFormat:@"%d", h]];
    [_average setText:[NSString stringWithFormat:@"%d", a]];
    [_playCount setText:[NSString stringWithFormat:@"%d", c]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
