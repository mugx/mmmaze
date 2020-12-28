//
//  TNEnemyCollaborator.h
//  mmmaze
//
//  Created by mugx on 23/03/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TNGameSession;
@class TNEnemy;

@interface TNEnemyCollaborator : NSObject
- (instancetype)init:(TNGameSession *)gameSession;
- (void)update:(CGFloat)deltaTime;
@property(readonly) NSMutableArray *enemies;
@end
