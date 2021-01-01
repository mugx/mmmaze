//
//  GameSession.h
//  mmmaze
//
//  Created by mugx on 10/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tile;
@class Player;

#define TILE_SIZE 32.0

@protocol GameSessionDelegate;
@class EnemyCollaborator;

@interface GameSession : NSObject
- (instancetype)initWithView:(UIView *)gameView;
- (void)update:(CGFloat)deltaTime;
- (void)makeMaze;

@property(nonatomic,assign) id <GameSessionDelegate> delegate;

@property(readwrite) NSUInteger currentLives;
@property(readwrite) NSTimeInterval currentTime;
@property(nonatomic,assign) BOOL isGameOver;

@property(nonatomic,assign) NSUInteger numRow;
@property(nonatomic,assign) NSUInteger numCol;
@property(nonatomic,strong) EnemyCollaborator *enemyCollaborator;
@property(nonatomic,strong) Player *player;

@property(nonatomic,assign,readwrite) NSUInteger currentLevel;
@property(nonatomic,assign,readwrite) NSUInteger currentScore;
@property(nonatomic,strong,readwrite) NSMutableDictionary<NSValue*, Tile *> *wallsDictionary;
@property(nonatomic,strong) NSMutableArray<Tile *> *items;

@property(nonatomic,strong,readwrite) UIView *mazeView;
@property(nonatomic,weak) UIView *gameView;
@property(nonatomic,weak) Tile *mazeGoalTile;
@property(nonatomic,assign) float mazeRotation;
@property(nonatomic,assign) BOOL isGameStarted;
@end

@protocol GameSessionDelegate <NSObject>
- (void)didUpdateScore:(NSUInteger)score;
- (void)didUpdateTime:(NSTimeInterval)time;
- (void)didUpdateLives:(NSUInteger)livesCount;
- (void)didUpdateLevel:(NSUInteger)levelCount;
- (void)didHurryUp;
- (void)didGameOver:(GameSession *)session;
@end
