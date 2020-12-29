//
//  GameSession.h
//  mmmaze
//
//  Created by mugx on 10/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNEnemyCollaborator.h"

@class TNPlayer;
@class TNTile;

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
@property(nonatomic,assign) id <GameSessionDelegate> delegate;

@property(readonly) NSUInteger currentLevel;
@property(readonly) NSUInteger currentScore;
@property(readwrite) NSUInteger currentLives;
@property(readwrite) CGFloat currentTime;
@property(nonatomic,assign) BOOL isGameOver;
@property(readonly) NSMutableArray<TNTile *> *items;

@property(nonatomic,assign) NSUInteger numRow;
@property(nonatomic,assign) NSUInteger numCol;
@property(readonly) NSMutableDictionary<NSValue *, TNTile *> *wallsDictionary;
@property(readonly) UIView *mazeView;
@property(nonatomic,strong) TNEnemyCollaborator *enemyCollaborator;
@property(nonatomic,strong) TNPlayer *player;
@end

@protocol GameSessionDelegate <NSObject>
- (void)didUpdateScore:(NSUInteger)score;
- (void)didUpdateTime:(NSUInteger)time;
- (void)didUpdateLives:(NSUInteger)livesCount;
- (void)didUpdateLevel:(NSUInteger)levelCount;
- (void)didHurryUp;
- (void)didGameOver:(GameSession *)session;
@end
