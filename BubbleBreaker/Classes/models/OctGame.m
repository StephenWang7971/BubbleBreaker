//
//  OctGame.m
//  BubbleBreaker
//
//  Created by stephen.wang on 13-1-5.
//  Copyright (c) 2013年 stephen.wang. All rights reserved.
//

#import "OctGame.h"
#import "OctBoard.h"
#import "OctScore.h"

#define MAX_COLUMN 10
#define MAX_ROW 10
#define MARKED_FLAG @"MARKED"

@implementation OctGame

@synthesize board = _board;
@synthesize score = _score;
@synthesize oldboard = _oldboard;
@synthesize selections = _selections;
@synthesize total = _total;
@synthesize gameover = _gameover;


-(void)start
{
    [_board shuffle];
    [_score clear];
    [_oldboard removeAllObjects];
    _gameover = NO;
}

static OctGame * instance = nil;


+(OctGame *)getInstance
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[OctGame alloc ]init];
        }
    }
    
    return instance;
}

-(id)init
{
	self=[super init];
	if(self){
        _board = [[OctBoard alloc]init];
        _score = [[OctScore alloc]init];
        _oldboard = [[NSMutableArray alloc]init];
        _selections =[[NSMutableDictionary alloc]init];
        
        NSArray *scores = [NSArray arrayWithContentsOfFile:@"/tmp/bubble_breaker.txt"];
        
        _score.highest = [scores[0] intValue];
        _score.playCount = [scores[1] intValue];
        _score.accumulate = [scores[2] intValue];
	}
	return self;
}

-(BOOL)startSelect:(int)row:(int)column
{
    OctBubble * bubble = _board.bubbles[row * MAX_COLUMN + column];
    if (bubble.destroyed) {
        return NO;
    }
    
    if(bubble.selected && !bubble.destroyed && [_selections count] > 1) {
        [self backup];

        _score.total += [self countScore];
        [self rupt:row:column];
        [self fallDown];
        [self magnet];
        return YES;
    }
    
    [self clearSelections];
    
    while(bubble != nil) {
        [self select: bubble.y:bubble.x];
        bubble = [self findNextUnmarkedBubble];
    }
    
    _score.selected =[self countScore];
    
    return NO;
}

-(void)select:(int)row :(int)column
{
    int index = row * MAX_COLUMN + column;
    OctBubble *b = _board.bubbles[index];
    b.selected = YES;
    [_selections setValue: MARKED_FLAG forKey: [NSString stringWithFormat:@"%d", index]];
    
    if(column > 0) {
        int leftIndex = row  * MAX_COLUMN + column - 1;
        OctBubble *left =_board.bubbles[leftIndex];
        if (left.color.color == b.color.color && !left.selected && !left.destroyed) {
            left.selected = YES;
            [_selections setValue: @"-----"  forKey: [NSString stringWithFormat:@"%d",leftIndex]];
        }
    }
    
    if(column < MAX_COLUMN - 1) {
        int rightIndex = row  * MAX_COLUMN + column + 1;
        OctBubble *right =_board.bubbles[rightIndex];
        if (right.color.color == b.color.color && !right.selected && !right.destroyed) {
            right.selected = YES;
            [_selections setValue: @"-----"  forKey: [NSString stringWithFormat:@"%d",rightIndex]];
        }
    }
    
    if(row > 0) {
        int upIndex = (row - 1) * MAX_COLUMN + column;
        OctBubble *up =_board.bubbles[upIndex];
        if (up.color.color == b.color.color && !up.selected && !up.destroyed) {
            up.selected = YES;
            [_selections setValue: @"-----"  forKey: [NSString stringWithFormat:@"%d",upIndex]];
        }
    }
    
    if(row < MAX_ROW - 1) {
        int downIndex = (row + 1) * MAX_COLUMN + column;
        OctBubble *down =_board.bubbles[downIndex];
        if (down.color.color == b.color.color && !down.selected && !down.destroyed) {
            down.selected = YES;
            [_selections setValue: @"-----"  forKey: [NSString stringWithFormat:@"%d",downIndex]];
        }
    }
}

-(OctBubble *)findNextUnmarkedBubble
{
    for (NSString *key in _selections) {
        NSString *value = [_selections objectForKey: key];
        if ([value isEqualToString: @"-----"]) {
            int index = [key intValue];
            return _board.bubbles[index];
        }
    }
    return nil;
}

-(void)rupt:(int)row :(int)column
{
    NSEnumerator * enumeratorKey = [_selections keyEnumerator];
    
    for (NSString *key in enumeratorKey) {
        int index = [key intValue];
        OctBubble *bubble =_board.bubbles[index];
        bubble.destroyed = YES;
    }
}

-(void)fallDown
{
    while ([self fillScreenHole]);
    [self clearSelections];
}

-(BOOL)fillScreenHole
{
    bool swapped = NO;
    
    for (int j = 0; j < MAX_COLUMN; j++) {
        for (int i = MAX_ROW - 1; i > 0; i--) {
            if ([self isDestroyedBall:i:j] && ![self isDestroyedBall:i-1:j]) {
                [self bubbleUp:i:j];
                swapped = YES;
            }
        }
    }
    return swapped;
}

-(void)bubbleUp:(int)row :(int)column
{
    OctBubble *bubble = _board.bubbles[row * MAX_COLUMN + column];
    OctBubble *up = _board.bubbles[(row - 1) * MAX_COLUMN + column];
    bool destroyed = bubble.destroyed;
    OctColor* color = bubble.color;
    bool selected = bubble.selected;
    bubble.destroyed = up.destroyed;
    bubble.color = up.color;
    bubble.selected = up.selected;
    up.destroyed = destroyed;
    up.color = color;
    up.selected = selected;
}

-(BOOL)isDestroyedBall:(int)row :(int)column
{
    OctBubble *bubble = _board.bubbles[row * MAX_COLUMN + column];
    return bubble.destroyed;
}

-(void)clearSelections
{
    for(int i = 0; i < MAX_ROW * MAX_COLUMN; i++)
    {
        OctBubble *bubble = _board.bubbles[i];
        bubble.selected = NO;
    }
    [_selections removeAllObjects];
}


-(void)magnet
{
    for(int i = 0; i < MAX_COLUMN; i++)
    {
        if([self isEmptyLine:i]) {
            [self jumpLeft:i];
        }
    }
}

-(BOOL)isEmptyLine:(int)column
{
    
    BOOL empty = YES;
    for(int row = 0; row < MAX_ROW; row++)
    {
        OctBubble * bubble = _board.bubbles[row * MAX_COLUMN + column];
        empty = empty & bubble.destroyed;
    }
    return empty;
}

-(void)jumpLeft:(int)column
{
    NSArray * emptyLine = [self saveEmptyLine:column];
    for (int i = column; i > 0; i--)
    {
        [self dragColumnFromLeft:i];
    }
    [self recoverEmptyLine:emptyLine ];
}

-(NSArray*)saveEmptyLine:(int)column
{
    NSMutableArray* emptyLine = [[NSMutableArray alloc]init];
    
    for(int row = 0; row < MAX_ROW; row++)
    {
        OctBubble * bubble = _board.bubbles[row * MAX_COLUMN + column];
        [emptyLine addObject:bubble];
    }
    
    return emptyLine;
}

-(void) dragColumnFromLeft:(int)column
{
    
    for(int row = 0; row < MAX_ROW; row++)
    {
        OctBubble * bubble = _board.bubbles[row * MAX_COLUMN + column];
        OctBubble * left = _board.bubbles[row * MAX_COLUMN + column - 1];
        bubble.color = left.color;
        bubble.selected = left.selected;
        bubble.destroyed = left.destroyed;
    }
}

-(void)recoverEmptyLine:(NSArray *)emptyLine
{
    
    for(int row = 0; row < MAX_ROW; row++)
    {
        OctBubble * bubble = _board.bubbles[row * MAX_COLUMN];
        OctBubble * empty = emptyLine[row];
        bubble.color = empty.color;
        bubble.selected = empty.selected;
        bubble.destroyed = YES;
    }
}

-(BOOL)isMutable
{
    for (int row = 0; row < MAX_ROW; row ++) {
        for (int column = 0; column < MAX_COLUMN; column++) {
            [_selections removeAllObjects];
            OctBubble * bubble = _board.bubbles[row * MAX_COLUMN + column];
            if (bubble.destroyed) {
                continue;
            }
            [self startSelect:row:column];
            if ([_selections count] > 1) {
                [self clearSelections];
                return YES;
            }
        }
    }
    [self clearSelections];
    return NO;
}

-(int)countScore
{
    int count = [_selections count];
   
    int score = 0;
    for (int i = 0; i <= count; i++)
    {
        score += [self accumulate:i ];
    }
    return score;
}

-(int) accumulate:(int)num
{
    int result = 0;
    for (int i = 0; i <= num; i++)
    {
        result += i;
    }
    return result;
}

-(int)countBonus
{
    return 0;
}

-(void)updateScore
{
    if (_score.highest < _score.total) {
        _score.highest = _score.total;
    }
    
    _score.playCount ++;
    _score.accumulate += _score.total;
   
    NSArray * scores = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%d", _score.highest],[NSString stringWithFormat:@"%d", _score.playCount],[NSString stringWithFormat:@"%d", _score.accumulate], nil];
    
    [scores writeToFile:@"/tmp/bubble_breaker.txt" atomically:YES];
    
}


-(int) getMinIndexOfSelection {
    NSEnumerator * enumeratorKey = [_selections keyEnumerator];
    
    int minIndex = 99;
    
    for (NSString *key in enumeratorKey) {
        if (minIndex > [key intValue]) {
            minIndex  = [key intValue];
        }
    }
    return minIndex;
}


-(void)backup{
    
    _total = _score.total;
    
    [_oldboard removeAllObjects];
    
    for (int i = 0; i < MAX_ROW; i++) {
        for (int j = 0; j < MAX_COLUMN; j++) {
            OctBubble * bubble = _board.bubbles[i * MAX_COLUMN + j];
            OctBubble * b = [[OctBubble alloc]init];
            b.x = bubble.x;
            b.y = bubble.y;
            b.color = bubble.color;
            b.selected = bubble.selected;
            b.destroyed = bubble.destroyed;
            [_oldboard addObject:b];
        }
    }
}


-(void)recover {
    [_board.bubbles removeAllObjects];
    
    _score.total = _total;
    
    for (int i = 0; i < MAX_ROW; i++) {
        for (int j = 0; j < MAX_COLUMN; j++) {
            [_board.bubbles addObject:_oldboard[i * MAX_COLUMN + j]];
        }
    }
}


-(BOOL) hasHistory{
    return [_oldboard count] >0;
}

@end
