//
//  TNEnemyCollaborator.h
//  mmmaze
//
//  Created by mugx on 23/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameSession;
@class TNEnemy;

@interface TNEnemyCollaborator : NSObject
- (instancetype)init:(GameSession *)gameSession;
- (void)update:(CGFloat)deltaTime;
@property(readonly) NSMutableArray *enemies;
@end
