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

@implementation EnemyCollaborator

#pragma mark - Private Functions

- (void)initEnemies
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
