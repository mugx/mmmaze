//
//  EnemyCollaborator.h
//  mmmaze
//
//  Created by mugx on 23/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameSession;
@class Enemy;

@interface EnemyCollaborator : NSObject
- (void)update:(CGFloat)deltaTime;
- (void)initEnemies;
@property(nonatomic,weak) GameSession *gameSession;
@property(nonatomic,assign) float enemyTimeAccumulator;
@property(nonatomic,strong,readwrite) NSMutableArray *enemies;
@property(nonatomic,strong,readwrite) NSMutableArray *spawnableEnemies;
@property(nonatomic,assign) BOOL medusaWasOut;
@property(nonatomic,assign) float speed;
@end
