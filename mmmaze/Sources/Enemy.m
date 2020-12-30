//
//  Enemy.m
//  mmmaze
//
//  Created by mugx on 23/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "Enemy.h"
#import "Tile+AI.h"
#import "mmmaze-Swift.h"

@implementation Enemy

- (void)update:(CGFloat)deltaTime
{
	self.upatePathAccumulator += deltaTime;

	CGRect originalFrame = [self originalFrame];
	
	if (self.path.count == 0) {
		NSArray *newPath = [self search: self.gameSession.player.frame];
		CGRect firstPathFrame = [self.path.firstObject CGRectValue];
		CGRect firstNewPathFrame = [newPath.firstObject CGRectValue];
		NSUInteger currentSteps = self.path.count;
		NSUInteger newSteps = newPath.count;

		BOOL hasToUpdatePath =
		currentSteps == 0 ||
		currentSteps > newSteps ||
		([self distanceWithRect1:originalFrame rect2:firstPathFrame] > [self distanceWithRect1:originalFrame rect2:firstNewPathFrame]);
		if (hasToUpdatePath)
		{
			self.upatePathAccumulator = 0;
			self.path = [NSMutableArray arrayWithArray:newPath];
		}
	}

	if (self.path.count > 0)
	{
		CGRect nextFrame = [self.path.firstObject CGRectValue];
		if ([self collidesWithTarget: originalFrame path: self.path]) {
			[self.path removeObject:[NSValue valueWithCGRect:originalFrame]];
		}

		float speed = self.speed + self.speed * deltaTime;
		CGRect eastFrame = CGRectMake(self.frame.origin.x - speed, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
		CGRect westFrame = CGRectMake(self.frame.origin.x  + speed, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
		CGRect northFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y - speed, self.frame.size.width, self.frame.size.height);
		CGRect southFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y + speed, self.frame.size.width, self.frame.size.height);
		BOOL collidesEast = [self checkWallCollision:eastFrame] != nil;
		BOOL collidesWest = [self checkWallCollision:westFrame] != nil;
		BOOL collidesNorth = [self checkWallCollision:northFrame] != nil;
		BOOL collidesSouth = [self checkWallCollision:southFrame] != nil;

		NSMutableArray *possibleDirections = [NSMutableArray array];
		if (!collidesEast) [possibleDirections addObject:@{@"move":@('e'), @"frame":[NSValue valueWithCGRect:eastFrame]}];
		if (!collidesWest) [possibleDirections addObject:@{@"move":@('w'), @"frame":[NSValue valueWithCGRect:westFrame]}];
		if (!collidesNorth) [possibleDirections addObject:@{@"move":@('n'), @"frame":[NSValue valueWithCGRect:northFrame]}];
		if (!collidesSouth) [possibleDirections addObject:@{@"move":@('s'), @"frame":[NSValue valueWithCGRect:southFrame]}];
		switch ([self getBestDirection:possibleDirections targetFrame:nextFrame])
		{
			case 'e':
				[self didSwipe:UISwipeGestureRecognizerDirectionLeft];
				break;
			case 'w':
				[self didSwipe:UISwipeGestureRecognizerDirectionRight];
				break;
			case 'n':
				[self didSwipe:UISwipeGestureRecognizerDirectionUp];
				break;
			case 's':
				[self didSwipe:UISwipeGestureRecognizerDirectionDown];
				break;
		}
	}
	[super update:deltaTime];
}

@end
