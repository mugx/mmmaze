//
//  Tile.m
//  mmmaze
//
//  Created by mugx on 29/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "Tile.h"
#import "mmmaze-Swift.h"

@implementation Tile

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	_animations = [NSMutableDictionary dictionary];
	return self;
}

- (Tile *)checkWallCollision:(CGRect)frame {
  NSArray *walls = [self.gameSession.wallsDictionary allValues];
  for (Tile *wall in walls) {
    if (wall.tag != TTExplodedWall && CGRectIntersectsRect(wall.frame, frame)) {
      return wall;
    }
  }
  return nil;
}

- (CGRect)wallCollision:(CGRect)frame {
  NSArray *walls = [self.gameSession.wallsDictionary allValues];
	for (Tile *wall in walls) {
    if (wall.tag != TTExplodedWall && CGRectIntersectsRect(wall.frame, frame)) {
      return CGRectIntersection(wall.frame, frame);
    }
  }
  return CGRectZero;
}

- (void)didSwipe:(UISwipeGestureRecognizerDirection)direction {
  self.lastSwipe = (int)direction;
  
  if (self.lastSwipe == UISwipeGestureRecognizerDirectionRight) {
    self.velocity = CGPointMake(self.speed, self.velocity.y);
  } else if (self.lastSwipe == UISwipeGestureRecognizerDirectionLeft) {
    self.velocity = CGPointMake(-self.speed, self.velocity.y);
  } else if (self.lastSwipe == UISwipeGestureRecognizerDirectionUp) {
    self.velocity = CGPointMake(self.velocity.x, -self.speed);
  } else if (self.lastSwipe == UISwipeGestureRecognizerDirectionDown) {
    self.velocity = CGPointMake(self.velocity.x, self.speed);
  }
}

- (void)update:(CGFloat)deltaTime
{
  CGRect frame = self.frame;
  float velx = self.velocity.x + self.velocity.x * deltaTime;
  float vely = self.velocity.y + self.velocity.y * deltaTime;
  bool didHorizontalMove = false;
  bool didVerticalMove = false;
  bool didWallExplosion = false;
  
  //--- checking horizontal move ---//
  if (velx < 0 || velx > 0) {
		CGRect frameOnHorizontalMove = CGRectMake(frame.origin.x + velx, frame.origin.y, frame.size.width, frame.size.height);

    self.collidedWall = [self checkWallCollision:frameOnHorizontalMove];
    if (!self.collidedWall) {
      didHorizontalMove = true;
      frame = frameOnHorizontalMove;
      
      if (vely != 0 && !(self.lastSwipe == UISwipeGestureRecognizerDirectionUp || self.lastSwipe == UISwipeGestureRecognizerDirectionDown)) {
        self.velocity = CGPointMake(self.velocity.x, 0);
      }
    }

		didWallExplosion = [self explodeWall];
  }
  
  //--- checking vertical move ---//
  if (vely < 0 || vely > 0) {
		CGRect frameOnVerticalMove = CGRectMake(frame.origin.x, frame.origin.y + vely, frame.size.width, frame.size.height);
    self.collidedWall = [self checkWallCollision:frameOnVerticalMove];
    if (!self.collidedWall) {
      didVerticalMove = true;
      frame = frameOnVerticalMove;
      
      if (velx != 0 && !(self.lastSwipe == UISwipeGestureRecognizerDirectionLeft || self.lastSwipe == UISwipeGestureRecognizerDirectionRight)) {
        self.velocity = CGPointMake(0, self.velocity.y);
      }
    }
    
		didWallExplosion = [self explodeWall];
  }
  
  if (didHorizontalMove || didVerticalMove || didWallExplosion) {
    self.frame = frame;
  } else {
    self.velocity = CGPointMake(0, 0);
  }
}

@end
