//
//  TNGameSession.m
//  mmmaze
//
//  Created by mugx on 10/03/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "MXAudioManager.h"

#import "mmmaze-Swift.h"
#import "TNGameSession.h"
#import "TNCollisionCollaborator.h"
#import "TNEnemyCollaborator.h"
#import "TNPlayer.h"
#import "TNEnemy.h"
#import "MXToolBox.h"
#import "TNMazeGenerator.hpp"

#define BASE_MAZE_DIMENSION 7
#define BKG_COLORS @[[UIColor whiteColor]]
//#define BKG_COLORS @[Constants.electricColor, Constants.blueColor, Constants.greenColor, Constants.cyanColor, Constants.yellowColor, Constants.redColor]

@interface TNGameSession ()
@property(nonatomic,assign,readwrite) NSUInteger currentLevel;
@property(nonatomic,assign,readwrite) NSUInteger currentScore;
@property(nonatomic,strong,readwrite) NSMutableDictionary<NSValue*, TNTile *> *wallsDictionary;
@property(nonatomic,strong) NSMutableArray<TNTile *> *items;

@property(nonatomic,assign) int bkgColorIndex;
@property(nonatomic,assign) float bkgColorTimeAccumulator;
@property(nonatomic,strong,readwrite) UIView *mazeView;
@property(nonatomic,weak) UIView *gameView;
@property(nonatomic,weak) TNTile *mazeGoalTile;
@property(nonatomic,assign) float mazeRotation;
@property(nonatomic,assign) BOOL isGameStarted;
@end

@implementation TNGameSession

- (instancetype)initWithView:(UIView *)gameView {
    self = [super init];
    _gameView = gameView;
    return self;
}

- (void)startLevel:(NSUInteger)levelNumber {
    self.gameView.alpha = 0;

    //--- setup gameplay varables ---//
    self.currentLevel = levelNumber;
    self.currentTime = MAX_TIME;
    self.isGameStarted = NO;

    if (levelNumber == 1) {
        //--- play start game sound ---//
        [[MXAudioManager sharedInstance] play:SoundTypeSTStartgame];
        self.currentScore = 0;
        self.currentLives = MAX_LIVES;
        self.numCol = BASE_MAZE_DIMENSION;
        self.numRow = BASE_MAZE_DIMENSION;
        self.bkgColorIndex = 0;
    } else {
        //--- play start level sound ---//
        [[MXAudioManager sharedInstance] play:SoundTypeSTLevelChange];
        self.bkgColorIndex = (self.bkgColorIndex + 1) % (BKG_COLORS.count);
    }

    //--- reset random rotation ---//
    self.gameView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);

    //--- remove old views ---//
    for (UIView *view in self.mazeView.subviews) {
        view.hidden = YES;
        [view removeFromSuperview];
    }

    //--- init scene elements ---//
    self.numCol = (self.numCol + 2) < 30 ? self.numCol + 2 : self.numCol;
    self.numRow = (self.numRow + 2) < 30 ? self.numRow + 2 : self.numRow;
    [self makeMaze];
    [self makePlayer];

    ///--- setup collaborator ---//
    self.collisionCollaborator = [[TNCollisionCollaborator alloc] init:self];
    self.enemyCollaborator = [[TNEnemyCollaborator alloc] init:self];

    //--- update external delegate ---//
    [self.delegate didUpdateScore:self.currentScore];
    [self.delegate didUpdateLives:self.currentLives];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.gameView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.delegate didUpdateLevel:self.currentLevel];
    }];
}

- (void)makeMaze {
    self.items = [NSMutableArray array];
    self.mazeView = [[UIView alloc] initWithFrame:self.gameView.frame];
    [self.gameView addSubview:self.mazeView];
    self.mazeRotation = 0;
    self.isGameOver = NO;

    //--- generating the maze ---//
    TNMazeGenerator *mazeGenerator = new TNMazeGenerator();
    MazeTyleType **maze = mazeGenerator->calculateMaze(static_cast<int>(STARTING_CELL.x), static_cast<int>(STARTING_CELL.y), static_cast<int>(self.numCol), static_cast<int>(self.numRow));
    self.wallsDictionary = [NSMutableDictionary dictionary];

    NSMutableArray *freeTiles = [NSMutableArray array];
    for (int r = 0; r < self.numRow ; r++)
    {
        for (int c = 0; c < self.numCol; c++)
        {
            if (maze[r][c] == MTWall)
            {
                TNTile *tile = [[TNTile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
                tile.tag = TTWall;
                [tile setImage:[[UIImage imageNamed:@"wall"] imageColored:BKG_COLORS[self.bkgColorIndex]]];
                tile.isDestroyable = !(r == 0 || c == 0 || r == self.numRow - 1 || c == self.numCol - 1);
                tile.x = r;
                tile.y = c;
                [self.mazeView addSubview:tile];
                [self.wallsDictionary setObject:tile forKey:[NSValue valueWithCGPoint:CGPointMake(r, c)]];
            }
            else if (maze[r][c] == MTStart)
            {
                TNTile *tile = [[TNTile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
                tile.x = r;
                tile.y = c;
                tile.tag = TTDoor;
                tile.isDestroyable = NO;
                [self.mazeView addSubview:tile];
                [self.items addObject:tile];
            }
            else if (maze[r][c] == MTEnd)
            {
                TNTile *tile = [[TNTile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
                tile.x = r;
                tile.y = c;
                tile.tag = TTMazeEnd_close;
                tile.isDestroyable = NO;
                [tile setImage:[UIImage imageNamed:@"gate_close"]];
                [self.mazeView addSubview:tile];
                [self.wallsDictionary setObject:tile forKey:[NSValue valueWithCGPoint:CGPointMake(r, c)]];
                self.mazeGoalTile = tile;
                [self.items addObject:tile];
            }
            else
            {
                TNTile *item = [self makeItem:c row:r];
                if (!item)
                {
                    [freeTiles addObject:@{@"c":@(c), @"r":@(r)}];
                }
            }
        }
    }

    //--- make key ---//
    NSDictionary *keyPosition = freeTiles[arc4random() % freeTiles.count];
    int c = [keyPosition[@"c"] intValue];
    int r = [keyPosition[@"r"] intValue];
    TNTile *keyItem = [[TNTile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
    keyItem.x = c;
    keyItem.y = r;
    keyItem.tag = TTKey;
    keyItem.image = [[UIImage imageNamed:@"key"] imageColored:Constants.magentaColor];
    [self.mazeView addSubview:keyItem];
    [self.items addObject:keyItem];

    for (int i = 0; i < self.numCol; ++i)
    {
        free(maze[i]);
    }
    free(maze);
}

- (TNTile *)makeItem:(int)col row:(int)row
{
    TNTile *item = [[TNTile alloc] initWithFrame:CGRectMake(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
    item.tag = -1;

    if ((arc4random() % 100) >= 50)
    {
        item.tag = TTCoin;
        item.image = [[UIImage imageNamed:@"coin"] imageColored:[UIColor yellowColor]];
        [item flip];
    }
    else if ((arc4random() % 100) >= 90)
    {
        item.tag = TTWhirlwind;
        item.image = [[UIImage imageNamed:@"whirlwind"] imageColored:BKG_COLORS[self.bkgColorIndex]];
        [item spin];
    }
    else if ((arc4random() % 100) >= 80)
    {
        item.tag = TTBomb;
        item.image = [[UIImage imageNamed:@"bomb"] imageColored:Constants.redColor];
    }
    else if ((arc4random() % 100) >= 98)
    {
        item.tag = TTTime;
        item.animationImages = [[UIImage imageNamed:@"time"] spritesWith:CGSizeMake(TILE_SIZE, TILE_SIZE)];
        item.animationDuration = 1;
        [item startAnimating];
    }
    else if ((arc4random() % 100) >= 99)
    {
        int minionSize = TILE_SIZE;
        item = [[TNTile alloc] initWithFrame:CGRectMake(col * minionSize, row * minionSize, minionSize, minionSize)];
        item.tag = TTMinion;
        item.image = [UIImage imageNamed:@"minion"];
    }

    if (item.tag != -1)
    {
        item.x = col;
        item.y = row;
        [self.mazeView addSubview:item];
        [self.items addObject:item];
        return item;
    }
    else
    {
        return nil;
    }
}

- (void)makePlayer
{
    if (self.player) {
        [self.player removeFromSuperview];
    }

  self.player = [[TNPlayer alloc] initWithFrame:CGRectMake(STARTING_CELL.y * TILE_SIZE + PLAYER_SPEED / 2.0, STARTING_CELL.x * TILE_SIZE + PLAYER_SPEED / 2.0, TILE_SIZE - PLAYER_SPEED, TILE_SIZE - PLAYER_SPEED) withGameSession:self];
  self.player.animationImages = [[UIImage imageNamed:@"player"] spritesWith:CGSizeMake(TILE_SIZE, TILE_SIZE)];
  self.player.animationDuration = 0.4f;
  self.player.animationRepeatCount = 0;
  [self.player startAnimating];
  [self.mazeView addSubview:self.player];
}


- (void)didSwipe:(UISwipeGestureRecognizerDirection)direction {
    self.isGameStarted = YES;
    [self.player didSwipe:direction];
}

- (void)respawnPlayerAtOrigin:(int)blinkingTime {
    self.player.isBlinking = YES;
    [UIView animateWithDuration:0.4 animations:^{
        self.player.velocity = CGPointZero;
        self.player.frame = CGRectMake(STARTING_CELL.y * TILE_SIZE + PLAYER_SPEED / 2.0, STARTING_CELL.x * TILE_SIZE + PLAYER_SPEED / 2.0, TILE_SIZE - PLAYER_SPEED, TILE_SIZE - PLAYER_SPEED);
        self.mazeView.frame = CGRectMake(self.mazeView.frame.size.width / 2.0 - self.player.frame.origin.x, self.mazeView.frame.size.height / 2.0 - self.player.frame.origin.y, self.mazeView.frame.size.width, self.mazeView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.player blink:blinkingTime completion:^{
            self.player.isBlinking = NO;
        }];
    }];
}

- (void)update:(CGFloat)deltaTime
{
  self.currentTime = self.currentTime - deltaTime > 0 ? self.currentTime - deltaTime : 0;
  [self.delegate didUpdateTime:self.currentTime];

  //--- hurry up ---//
  if (self.currentTime <= 10)
  {
    [self.delegate didHurryUp];
  }

  //--- updating enemies stuff ---//
  if (self.isGameStarted)
  {
    [self.enemyCollaborator update:deltaTime];
  }

  //--- checking walls collisions ---//
  if (!self.isGameOver)
  {
    [self.player update:deltaTime];
  }

  //--- checking items collisions ---//
  NSMutableArray *itemsToRemove = [NSMutableArray array];
  for (TNTile *item in self.items)
  {
    if (CGRectIntersectsRect(item.frame, self.player.frame))
    {
      if (item.tag == TTCoin)
      {
        [[MXAudioManager sharedInstance] play:SoundTypeSTHitCoin];
        item.hidden = true;
        [itemsToRemove addObject:item];
        self.currentScore += 15;
        [self.delegate didUpdateScore:self.currentScore];
      }
      else if (item.tag == TTWhirlwind)
      {
        [[MXAudioManager sharedInstance] play:SoundTypeSTHitWhirlwind];
        item.hidden = true;
        [itemsToRemove addObject:item];
        [UIView animateWithDuration:0.2 animations:^{
					self.mazeRotation += M_PI_2;
					self.gameView.transform = CGAffineTransformRotate(self.gameView.transform, M_PI_2);
					self.player.transform = CGAffineTransformRotate(self.player.transform, -M_PI_2);;//CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2 * (self.lastFacing == FTWest ? 1 : -1));
        }];
      }
      else if (item.tag == TTTime)
      {
        [[MXAudioManager sharedInstance] play:SoundTypeSTHitTimeBonus];
        item.hidden = true;
        [itemsToRemove addObject:item];
        self.currentTime += 5;
      }
      else if (item.tag == TTKey)
      {
        [[MXAudioManager sharedInstance] play:SoundTypeSTHitMinion];
        item.hidden = true;
        [itemsToRemove addObject:item];
        self.mazeGoalTile.tag = TTMazeEnd_open;
        [self.mazeGoalTile setImage:[UIImage imageNamed:@"gate_open"]];
        [self.wallsDictionary removeObjectForKey:[NSValue valueWithCGPoint:CGPointMake(self.mazeGoalTile.x, self.mazeGoalTile.y)]];
      }
      else if (item.tag == TTMinion)
      {
        [[MXAudioManager sharedInstance] play:SoundTypeSTHitMinion];
        item.hidden = true;
        [itemsToRemove addObject:item];
        ++self.currentLives;
        [self.delegate didUpdateLives:self.currentLives];
      }
      else if (item.tag == TTBomb)
      {
        [[MXAudioManager sharedInstance] play:SoundTypeSTHitBomb];
        item.hidden = true;
        [itemsToRemove addObject:item];
        int player_x = (int)self.player.frame.origin.x;
        int player_y = (int)self.player.frame.origin.y;
        self.player.isAngry = YES;

        for (TNTile *tile in [self.wallsDictionary allValues])
        {
          if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x + TILE_SIZE, player_y, TILE_SIZE, TILE_SIZE)))
          {
            [tile explode:nil];
            tile.tag = TTExplodedWall;
          }
          else if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x - TILE_SIZE, player_y, TILE_SIZE, TILE_SIZE)))
          {
            [tile explode:nil];
            tile.tag = TTExplodedWall;
          }

          if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x, player_y + TILE_SIZE, TILE_SIZE, TILE_SIZE)))
          {
            [tile explode:nil];
            tile.tag = TTExplodedWall;
          }

          if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x, player_y - TILE_SIZE, TILE_SIZE, TILE_SIZE)))
          {
            [tile explode:nil];
            tile.tag = TTExplodedWall;
          }
        }
      }
    }
    else
    {
      if (item.tag == TTBomb)
      {
        for (TNEnemy *enemy in self.enemyCollaborator.enemies)
        {
          if (CGRectIntersectsRect(enemy.frame, item.frame))
          {
            item.hidden = true;
            [itemsToRemove addObject:item];
            enemy.wantSpawn = YES;
            [[MXAudioManager sharedInstance] play:SoundTypeSTEnemySpawn];
            break;
          }
        }
      }
    }
    item.transform = CGAffineTransformMakeRotation(-self.mazeRotation);
  }
  [self.items removeObjectsInArray:itemsToRemove];

  //--- updating maze frame ---//
  self.mazeView.frame = CGRectMake(self.mazeView.frame.size.width / 2.0 - self.player.frame.origin.x, self.mazeView.frame.size.height / 2.0 - self.player.frame.origin.y, self.mazeView.frame.size.width, self.mazeView.frame.size.height);

  ///--- collision player vs enemies ---//
  for (TNEnemy *enemy in self.enemyCollaborator.enemies)
  {
    if (!self.player.isBlinking && self.currentLives > 0 && CGRectIntersectsRect(enemy.frame, self.player.frame))
    {
      if (!self.player.isAngry)
      {
        [[MXAudioManager sharedInstance] play:SoundTypeSTHitPlayer];
        enemy.wantSpawn = YES;
        self.currentLives = self.currentLives - 1;
        [self.delegate didUpdateLives:self.currentLives];
        if (self.currentLives > 0) {
					[self respawnPlayerAtOrigin:2];
        }
      }
      else
      {
        [UIView animateWithDuration:0.4 animations:^{
          enemy.velocity = CGPointZero;
          enemy.frame = CGRectMake(STARTING_CELL.y * TILE_SIZE + enemy.speed / 2.0, STARTING_CELL.x * TILE_SIZE + enemy.speed / 2.0, TILE_SIZE - enemy.speed, TILE_SIZE - enemy.speed);
        } completion:^(BOOL finished) {
          self.player.isAngry = NO;
        }];
      }
      break;
    }
  }

  //--- collision player vs maze goal---//
  if (self.mazeGoalTile.tag == TTMazeEnd_open  && CGRectIntersectsRect(self.player.frame, self.mazeGoalTile.frame))
  {
    [self startLevel:self.currentLevel + 1];
    self.currentScore += 100;
  }

  //--- collision if player is dead---//
  if (!self.isGameOver && (self.currentLives == 0 || self.currentTime <= 0))
  {
    self.isGameOver = YES;
    [[MXAudioManager sharedInstance] play:SoundTypeSTGameOver];
    [self.player explode:^{
      [self.delegate performSelector:@selector(didGameOver:) withObject:self];
    }];
  }
}
@end
