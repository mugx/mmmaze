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

- (NSArray *)search:(CGRect)target
{
  CGRect originalFrame = CGRectMake((int)roundf(self.frame.origin.x / TILE_SIZE) * TILE_SIZE, (int)roundf(self.frame.origin.y / TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
  CGRect currentFrame = CGRectMake((int)roundf(self.frame.origin.x / TILE_SIZE) * TILE_SIZE, (int)roundf(self.frame.origin.y / TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
  CGFloat currentSpeed = TILE_SIZE;
  CGFloat currentSize = TILE_SIZE;
  NSMutableArray *path = [@[[NSValue valueWithCGRect:currentFrame]] mutableCopy];
  bool targetFound = false;
  do
  {

		targetFound = [self collidesWithTarget:target path:path];
		if (targetFound) {
      [path removeObject:[NSValue valueWithCGRect:originalFrame]];
      break;
    } else {
      CGRect eastFrame = CGRectMake(currentFrame.origin.x - currentSpeed, currentFrame.origin.y, currentSize, currentSize);
      CGRect westFrame = CGRectMake(currentFrame.origin.x + currentSpeed, currentFrame.origin.y, currentSize, currentSize);
      CGRect northFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y - currentSpeed, currentSize, currentSize);
      CGRect southFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + currentSpeed, currentSize, currentSize);
      BOOL collidesEast = [self collidesEastOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:eastFrame]];
      BOOL collidesWest = [self collidesWestOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:westFrame]];
      BOOL collidesNorth = [self collidesNorthOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:northFrame]];
      BOOL collidesSouth = [self collidesSouthOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:southFrame]];
      
      NSMutableArray *possibleDirections = [NSMutableArray array];
      if (!collidesEast) [possibleDirections addObject:@{@"move":@"e", @"frame":[NSValue valueWithCGRect:eastFrame]}];
      if (!collidesWest) [possibleDirections addObject:@{@"move":@"w", @"frame":[NSValue valueWithCGRect:westFrame]}];
      if (!collidesNorth) [possibleDirections addObject:@{@"move":@"n", @"frame":[NSValue valueWithCGRect:northFrame]}];
      if (!collidesSouth) [possibleDirections addObject:@{@"move":@"s", @"frame":[NSValue valueWithCGRect:southFrame]}];
      
      if (possibleDirections.count > 0)
      {
        NSString* direction = [self getBestDirection:possibleDirections targetFrame:target];
				if ([direction isEqualToString:@"n"]) {
					currentFrame = northFrame;
				} else if ([direction isEqualToString:@"s"]) {
					currentFrame = southFrame;
				} else if ([direction isEqualToString:@"e"]) {
					currentFrame = eastFrame;
				} else if ([direction isEqualToString:@"w"]) {
					currentFrame = westFrame;
				}
        [path addObject:[NSValue valueWithCGRect:currentFrame]];
      } else {
        // backtracking
        NSInteger currentIndex = [path indexOfObject:[NSValue valueWithCGRect:currentFrame]];
        if (currentIndex) {
          currentFrame = [[path objectAtIndex:currentIndex -1] CGRectValue];
        }
      }
    }
  } while(!targetFound);
  return path;
}

@end
