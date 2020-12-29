//
//  GameSession.h
//  mmmaze
//
//  Created by mugx on 10/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnemyCollaborator.h"

@class Tile;

#define TILE_SIZE 32.0
#define STARTING_CELL CGPointMake(1,1)
#define MAX_TIME 60
#define MAX_LIVES 3

@protocol GameSessionDelegate;

@interface GameSession : NSObject
- (instancetype)initWithView:(UIView *)gameView;
- (void)startLevel:(NSUInteger)levelNumber;
- (void)didSwipe:(UISwipeGestureRecognizerDirection)direction;
- (void)update:(CGFloat)deltaTime;
- (void)makePlayer;
- (CGRect)playerFrame;
@property(nonatomic,assign) id <GameSessionDelegate> delegate;

@property(readonly) NSUInteger currentLevel;
@property(readonly) NSUInteger currentScore;
@property(readwrite) NSUInteger currentLives;
@property(readwrite) CGFloat currentTime;
@property(nonatomic,assign) BOOL isGameOver;
@property(readonly) NSMutableArray<Tile *> *items;

@property(nonatomic,assign) NSUInteger numRow;
@property(nonatomic,assign) NSUInteger numCol;
@property(readonly) NSMutableDictionary<NSValue *, Tile *> *wallsDictionary;
@property(readonly) UIView *mazeView;
@property(nonatomic,strong) EnemyCollaborator *enemyCollaborator;
@end

@protocol GameSessionDelegate <NSObject>
- (void)didUpdateScore:(NSUInteger)score;
- (void)didUpdateTime:(NSUInteger)time;
- (void)didUpdateLives:(NSUInteger)livesCount;
- (void)didUpdateLevel:(NSUInteger)levelCount;
- (void)didHurryUp;
- (void)didGameOver:(GameSession *)session;
@end
