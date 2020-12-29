//
//  TNEnemy.h
//  mmmaze
//
//  Created by mugx on 23/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSession.h"
#import "TNTile.h"

#define ENEMY_SPEED 1.5

@interface TNEnemy : TNTile
- (instancetype)initWithFrame:(CGRect)frame withGameSession:(GameSession *)gameSession;
- (void)update:(CGFloat)deltaTime;
@property(nonatomic,assign) BOOL wantSpawn;
@end
