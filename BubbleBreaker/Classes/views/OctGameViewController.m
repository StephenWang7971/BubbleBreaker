//
//  OctFirstViewController.m
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import "OctGameViewController.h"
#import "OctGame.h"

#define MAX_COLUMN 10
#define MAX_ROW 10

@interface OctGameViewController ()

@end

@implementation OctGameViewController

@synthesize bubbles = _bubbles;
@synthesize score = _score;
@synthesize selected = _selected;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _bubbles = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < MAX_ROW; i++)
    {
        for (int j = 0; j < MAX_COLUMN; j++)
        {
            UIImageView *imageView = [[UIImageView alloc]init];
    
            [[self view] addSubview:imageView];
            
            [_bubbles addObject:imageView];
            [imageView setTag:i * MAX_COLUMN + j];
            
            //TODO use it for next click.
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView addGestureRecognizer:singleTap];
            //[singleTap release];
            
            //[imageView release];
        }
    }
        
    _score = [[UILabel alloc]init];
    [[self view] addSubview:_score];

    CGRect newFrame = CGRectMake(60, 8, 50, 15);
    [_score setFrame:newFrame];
    
    _selected = [[UILabel alloc]init];
    [[self view] addSubview:_selected];
    _selected.textColor = [UIColor whiteColor];
    _selected.backgroundColor = [UIColor blackColor];
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *bubble = [gestureRecognizer view];
    
    int index = [bubble tag];
    OctGame * game = [OctGame getInstance];
    
    int column = index % MAX_COLUMN;
    int row = index / MAX_COLUMN;
    
    BOOL fallen = [game startSelect:row:column];
    int minSelectedIndex = [game getMinIndexOfSelection];

    if (fallen){
        if(![game isMutable]) {
            [game countBonus];
            [self gameOver];
        }
    }
    [self render:fallen:minSelectedIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGame:(id)sender
{
    OctGame * game = [OctGame getInstance];
    [game start];
    [self render:YES:0];
}

- (void) render:(BOOL)fallen:(int)minSelectedIndex
{
    OctGame * game = [OctGame getInstance];
    for (OctBubble *b in game.board.bubbles)
    {
        UIImageView *imageView = _bubbles[b.y * MAX_COLUMN + b.x];

        UIImage * img;
        if (!b.destroyed && !b.selected)
        {
            img = b.color.image;
        }
        else if (b.destroyed)
        {   img = nil;//transparent;
        }
        else if (!b.destroyed && b.selected)
        {
            img = b.color.selected;
        }
        [imageView setImage: img];
        
        CGRect newFrame = CGRectMake(b.x * 32, b.y * 32 + 80, img.size.width, img.size.height);
        [imageView setFrame:newFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if(!fallen) {
        int selectedScore = game.score.selected;
        [_selected setText: [NSString stringWithFormat:@"%d",selectedScore]];
        
        int row = minSelectedIndex / MAX_COLUMN;
        int column = minSelectedIndex % MAX_COLUMN;

        int left = 0;
        if (column < MAX_COLUMN - 1) {
            left = (column + 1) * 32;
        } else {
            left = column * 32;
        }
        int top = row * 32 + 65;
        
        _selected.hidden = NO;
        CGRect tempFrame = CGRectMake(left, top, 40, 15);
        [_selected setFrame:tempFrame];
        
    } else {
        int total = game.score.total;
         [_score setText: [NSString stringWithFormat:@"%d",total]];
         _selected.hidden = YES;
    }
    
}

-(void) gameOver
{
    
    OctGame* game = [OctGame getInstance];
    game.gameover = YES;
    
    [game updateScore];
    
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"游戏结束"
                         message:@"已经没有更多的可以消除的小球了。"
                         delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alert show];
    //[alert release];
}

- (IBAction)regretOneStep:(id)sender {
    OctGame * game =[OctGame getInstance];
    if ([game hasHistory] && !game.gameover) {
        [game recover];
        [self render:YES :0];
    }
}
@end
