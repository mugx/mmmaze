//
//  Tile.h
//  mmmaze
//
//  Created by mugx on 29/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameSession.h"

typedef NS_ENUM(NSUInteger, TyleType) {
  TTDoor,
  TTWall,
  TTExplodedWall,
  TTCoin,
  TTWhirlwind,
  TTBomb,
  TTTime,
  TTHearth,
  TTKey,
  TTMazeEnd_close,
  TTMazeEnd_open
};

@interface Tile : UIImageView
- (void)restoreAnimations;
- (void)spin;
- (void)flip;
- (Tile *)checkWallCollision:(CGRect)frame;
- (bool)collidesNorthOf:(CGRect)frame;
- (bool)collidesSouthOf:(CGRect)frame;
- (bool)collidesWestOf:(CGRect)frame;
- (bool)collidesEastOf:(CGRect)frame;
- (void)didSwipe:(UISwipeGestureRecognizerDirection)direction;
- (void)update:(CGFloat)updateTime;
@property(nonatomic,assign) CGPoint velocity;
@property(nonatomic,assign) float speed;
@property(nonatomic,assign) bool didVerticalSwipe;
@property(nonatomic,assign) bool didHorizontalSwipe;
@property(nonatomic,assign) int x;
@property(nonatomic,assign) int y;
@property(nonatomic,assign) BOOL isDestroyable;
@property(nonatomic,assign) BOOL isBlinking;
@property(nonatomic,assign) BOOL isAngry;
@property(nonatomic,weak) Tile *collidedWall;
@property(nonatomic,weak) GameSession *gameSession;
@end
