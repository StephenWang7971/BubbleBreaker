//
//  OctGame.h
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OctBoard.h"
#import "OctScore.h"


@interface OctGame : NSObject
{
}

@property (retain, nonatomic) OctBoard *board;
@property (retain, nonatomic) OctScore *score;
@property (retain, nonatomic) NSMutableArray* oldboard;
@property int total;
@property BOOL gameover;

@property (strong, nonatomic) NSMutableDictionary* selections;

-(void) start;
+(OctGame*)getInstance;
-(id)init;
-(BOOL)startSelect:(int)row:(int)column;
-(void)select:(int)row :(int)column;
-(void)rupt:(int)row :(int)column;
-(OctBubble*)findNextUnmarkedBubble;
-(void)fallDown;
-(BOOL)fillScreenHole;
-(void)bubbleUp:(int)row:(int)column;
-(BOOL)isDestroyedBall:(int)row:(int)column;
-(void)clearSelections;

-(void)magnet;
-(BOOL)isMutable;
-(int)countScore;
- (void) updateScore;
-(int)accumulate:(int)num;

-(int)countBonus;
-(void)gameOver;
-(void)jumpLeft:(int)column;
-(BOOL)isEmptyLine:(int)column;
-(NSArray*) saveEmptyLine:(int)column;
-(void)dragColumnFromLeft:(int)column;
-(void)recoverEmptyLine:(NSArray*)emptyLine;

-(int)getMinIndexOfSelection;

-(void)backup;
-(void)recover;
-(BOOL) hasHistory;

@end
