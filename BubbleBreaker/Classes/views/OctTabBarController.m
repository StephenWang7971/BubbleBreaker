//
//  OctTabBarController.m
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-7.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import "OctTabBarController.h"
#import "OctScoresViewController.h"
#import "OctGame.h"


@implementation OctTabBarController
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 1:
            [self display];
            break;
            
        default:
            break;
    }
    
}

-(void)display {
    OctScoresViewController* scoreView = self.childViewControllers[1];
    
    [scoreView displayScore];
}

@end
