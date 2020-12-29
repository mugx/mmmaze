//
//  Player.m
//  mmmaze
//
//  Created by mugx on 17/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "mmmaze-Swift.h"
#import "Player.h"
#import "MXToolBox.h"
#import "GameSession.h"

@interface Player()
@end

@implementation Player
@synthesize isAngry = _isAngry;

- (instancetype)initWithFrame:(CGRect)frame withGameSession:(GameSession *)gameSession
{
  self = [super initWithFrame:frame];
  self.gameSession = gameSession;
  self.speed = PLAYER_SPEED;
  self.layer.zPosition = 10;
  return self;
}

- (void)setIsAngry:(BOOL)isAngry
{
  _isAngry = isAngry;
  
  self.animationImages = [[UIImage imageNamed:isAngry ? @"player_angry" : @"player"] spritesWith:CGSizeMake(TILE_SIZE, TILE_SIZE)];
  [self startAnimating];
}

- (void)didSwipe:(UISwipeGestureRecognizerDirection)direction
{
  [super didSwipe:direction];
}

- (void)update:(CGFloat)deltaTime
{
  [super update:deltaTime];

  if (self.collidedWall) {
    CGRect intersection = CGRectIntersection(self.collidedWall.frame, self.frame);
    if (intersection.size.width < 3 && intersection.size.height)
    {
      self.collidedWall.tag = TTExplodedWall;
      [self.collidedWall explode:nil];
    }
    self.collidedWall = nil;
  }
}

@end
