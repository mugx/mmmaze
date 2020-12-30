//
//  EnemyCollaborator.m
//  mmmaze
//
//  Created by mugx on 23/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "mmmaze-Swift.h"
#import "EnemyCollaborator.h"
#import "Enemy.h"
#import "ToolBox.h"

#define MAX_ENEMIES 5

@interface EnemyCollaborator()
@property(nonatomic,weak) GameSession *gameSession;
@property(nonatomic,assign) float enemyTimeAccumulator;
@property(nonatomic,strong,readwrite) NSMutableArray *enemies;
@property(nonatomic,strong,readwrite) NSMutableArray *spawnableEnemies;
@property(nonatomic,assign) BOOL medusaWasOut;
@property(nonatomic,assign) float speed;
@end

@implementation EnemyCollaborator

- (instancetype)init:(GameSession *)gameSession
{
  self = [super init];
  _gameSession = gameSession;
  [self _initEnemies];
  return self;
}

#pragma mark - Private Functions

- (void)_initEnemies
{
  self.enemies = [NSMutableArray array];
  self.spawnableEnemies = [NSMutableArray array];
  self.speed = Enemy.SPEED + 0.1 * (self.gameSession.currentLevel - 1);
  if (self.speed > Player.SPEED)
  {
    self.speed = Player.SPEED;
  }
  for (int i = 0;i < MAX_ENEMIES;++i)
  {
		CGRect frame = CGRectMake(STARTING_CELL.y * TILE_SIZE + self.speed / 2.0, STARTING_CELL.x * TILE_SIZE + self.speed / 2.0, TILE_SIZE - self.speed, TILE_SIZE - self.speed);
    Enemy *enemy = [[Enemy alloc] initWithFrame:frame gameSession:self.gameSession];
    enemy.animationDuration = 0.4f;
    enemy.animationRepeatCount = 0;
    enemy.alpha = 0.0;
    enemy.hidden = YES;
    enemy.wantSpawn = i == 0;
    [self.gameSession.mazeView addSubview:enemy];
    [self.spawnableEnemies addObject:enemy];
  }
}

- (void)spawnFrom:(Enemy *)enemy
{
  for (Enemy *currentEnemy in self.spawnableEnemies)
  {
    if (currentEnemy.hidden)
    {
        currentEnemy.animationImages = [[UIImage imageNamed:@"enemy"] spritesWith:CGSizeMake(TILE_SIZE, TILE_SIZE)];
      [currentEnemy startAnimating];
      [self.spawnableEnemies removeObject:currentEnemy];
      [self.enemies addObject:currentEnemy];
      [UIView animateWithDuration:0.5 delay:1.0 options:0 animations:^{
        currentEnemy.hidden = NO;
        currentEnemy.alpha = 1.0;
      } completion:^(BOOL finished) {
        currentEnemy.speed = self.speed;
      }];
      currentEnemy.frame = enemy.frame;
      break;
    }
  }
}

#pragma mark - Public Functions

- (void)update:(CGFloat)deltaTime
{
  self.enemyTimeAccumulator += deltaTime;
  if (self.enemyTimeAccumulator > 1)
  {
    self.enemyTimeAccumulator = 0;
    NSArray *enemiesArray = self.enemies.count == 0 ? self.spawnableEnemies : self.enemies;
    for (Enemy *enemy in enemiesArray)
    {
      if (enemy.wantSpawn)
      {
        enemy.wantSpawn = NO;
        [self spawnFrom:enemy];
        break;
      }
    }
  }
  
  for (Enemy *enemy in self.enemies)
  {
    [enemy update:deltaTime];
  }
}

@end
