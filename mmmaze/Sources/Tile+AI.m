//
//  Tile+AI.m
//  mmmaze
//
//  Created by mugx on 15/04/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "Tile+AI.h"
#import "mmmaze-Swift.h"

@implementation Tile (AI)

//- (NSArray *)search:(CGRect)target
//{
//  CGRect originalFrame = CGRectMake((int)roundf(self.frame.origin.x / TILE_SIZE) * TILE_SIZE, (int)roundf(self.frame.origin.y / TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
//  CGRect currentFrame = CGRectMake((int)roundf(self.frame.origin.x / TILE_SIZE) * TILE_SIZE, (int)roundf(self.frame.origin.y / TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
//  CGFloat currentSpeed = TILE_SIZE;
//  CGFloat currentSize = TILE_SIZE;
//  NSMutableArray *path = [@[[NSValue valueWithCGRect:currentFrame]] mutableCopy];
//  bool targetFound = false;
//
//	do
//  {
//		targetFound = [self collidesWithTarget:target path:path];
//		if (targetFound) {
//      [path removeObject:[NSValue valueWithCGRect:originalFrame]];
//      break;
//    } else {
//			CGRect upFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y - currentSpeed, currentSize, currentSize);
//			CGRect downFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + currentSpeed, currentSize, currentSize);
//      CGRect leftFrame = CGRectMake(currentFrame.origin.x - currentSpeed, currentFrame.origin.y, currentSize, currentSize);
//      CGRect rightFrame = CGRectMake(currentFrame.origin.x + currentSpeed, currentFrame.origin.y, currentSize, currentSize);
//			BOOL collidesUp = [self isWallAt:currentFrame direction:UISwipeGestureRecognizerDirectionUp] || [path containsObject:[NSValue valueWithCGRect: upFrame]];
//			BOOL collidesDown = [self isWallAt:currentFrame direction:UISwipeGestureRecognizerDirectionDown] || [path containsObject:[NSValue valueWithCGRect: downFrame]];
//      BOOL collidesLeft = [self isWallAt:currentFrame direction:UISwipeGestureRecognizerDirectionLeft] || [path containsObject:[NSValue valueWithCGRect: leftFrame]];
//      BOOL collidesRight = [self isWallAt:currentFrame direction:UISwipeGestureRecognizerDirectionRight] || [path containsObject:[NSValue valueWithCGRect: rightFrame]];
//
//      NSMutableArray *possibleDirections = [NSMutableArray array];
//			if (!collidesUp) [possibleDirections addObject:@{@"move":@"up", @"frame":[NSValue valueWithCGRect:upFrame]}];
//			if (!collidesDown) [possibleDirections addObject:@{@"move":@"down", @"frame":[NSValue valueWithCGRect:downFrame]}];
//			if (!collidesLeft) [possibleDirections addObject:@{@"move":@"left", @"frame":[NSValue valueWithCGRect:leftFrame]}];
//      if (!collidesRight) [possibleDirections addObject:@{@"move":@"right", @"frame":[NSValue valueWithCGRect:rightFrame]}];
//
//      if (possibleDirections.count > 0)
//      {
//        NSString* direction = [self getBestDirection:possibleDirections targetFrame:target];
//				if ([direction isEqualToString:@"up"]) {
//					currentFrame = upFrame;
//				} else if ([direction isEqualToString:@"down"]) {
//					currentFrame = downFrame;
//				} else if ([direction isEqualToString:@"left"]) {
//					currentFrame = leftFrame;
//				} else if ([direction isEqualToString:@"right"]) {
//					currentFrame = rightFrame;
//				}
//        [path addObject:[NSValue valueWithCGRect:currentFrame]];
//      } else {
//        // backtracking
//        NSInteger currentIndex = [path indexOfObject:[NSValue valueWithCGRect:currentFrame]];
//        if (currentIndex) {
//          currentFrame = [[path objectAtIndex:currentIndex -1] CGRectValue];
//        }
//      }
//    }
//  } while(!targetFound);
//  return path;
//}
//
@end
