//
//  Tile+AI.m
//  mmmaze
//
//  Created by mugx on 15/04/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "Tile+AI.h"

@implementation Tile (AI)

CGFloat distance(CGRect rect1, CGRect rect2)
{
  return manhattanDistance(rect1, rect2);
}

CGFloat manhattanDistance(CGRect rect1, CGRect rect2)
{
  return fabs(rect1.origin.x - rect2.origin.x) + fabs(rect1.origin.y - rect2.origin.y);
}

CGFloat chebyshevDistance(CGRect rect1, CGRect rect2)
{
  return MAX(fabs(rect1.origin.x - rect2.origin.x), fabs(rect1.origin.y - rect2.origin.y));
}

CGFloat euclideanDistance(CGRect rect1, CGRect rect2)
{
   //--- euclidean ---//
   CGPoint center1 = CGPointMake(CGRectGetMidX(rect1), CGRectGetMidY(rect1));
   CGPoint center2 = CGPointMake(CGRectGetMidX(rect2), CGRectGetMidY(rect2));
   CGFloat horizontalDistance = (center2.x - center1.x);
   CGFloat verticalDistance = (center2.y - center1.y);
   CGFloat distance = sqrt((horizontalDistance * horizontalDistance) + (verticalDistance * verticalDistance));
   return distance;
}

- (bool)collidesTarget:(CGRect)target path:(NSArray *)path
{
  for (NSValue *cell in path)
  {
    if (CGRectIntersectsRect(target, [cell CGRectValue]))
    {
      return true;
    }
  }
  return false;
}

- (char)getBestDirection:(NSArray *)directions targetFrame:(CGRect)targetFrame
{
  CGFloat bestManhattan = FLT_MAX;
  char bestDirection = ' ';
  for (NSDictionary * direction in directions)
  {
    CGRect frame = [direction[@"frame"] CGRectValue];
    char move = [direction[@"move"] charValue];
    CGFloat manhattan = euclideanDistance(frame, targetFrame);
    if (manhattan < bestManhattan)
    {
      bestManhattan = manhattan;
      bestDirection = move;
    }
  }
  return bestDirection;
}

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
    targetFound = [self collidesTarget:target path:path];
    if (targetFound)
    {
      [path removeObject:[NSValue valueWithCGRect:originalFrame]];
      break;
    }
    else
    {
      CGRect eastFrame = CGRectMake(currentFrame.origin.x - currentSpeed, currentFrame.origin.y, currentSize, currentSize);
      CGRect westFrame = CGRectMake(currentFrame.origin.x + currentSpeed, currentFrame.origin.y, currentSize, currentSize);
      CGRect northFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y - currentSpeed, currentSize, currentSize);
      CGRect southFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + currentSpeed, currentSize, currentSize);
      BOOL collidesEast = [self collidesEastOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:eastFrame]];
      BOOL collidesWest = [self collidesWestOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:westFrame]];
      BOOL collidesNorth = [self collidesNorthOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:northFrame]];
      BOOL collidesSouth = [self collidesSouthOf:currentFrame] || [path containsObject:[NSValue valueWithCGRect:southFrame]];
      
      NSMutableArray *possibleDirections = [NSMutableArray array];
      if (!collidesEast) [possibleDirections addObject:@{@"move":@('e'), @"frame":[NSValue valueWithCGRect:eastFrame]}];
      if (!collidesWest) [possibleDirections addObject:@{@"move":@('w'), @"frame":[NSValue valueWithCGRect:westFrame]}];
      if (!collidesNorth) [possibleDirections addObject:@{@"move":@('n'), @"frame":[NSValue valueWithCGRect:northFrame]}];
      if (!collidesSouth) [possibleDirections addObject:@{@"move":@('s'), @"frame":[NSValue valueWithCGRect:southFrame]}];
      
      if (possibleDirections.count > 0)
      {
        char direction = [self getBestDirection:possibleDirections targetFrame:target];
        switch(direction)
        {
          case 'n':
            currentFrame = northFrame;
            break;
          case 's':
            currentFrame = southFrame;
            break;
          case 'e':
            currentFrame = eastFrame;
            break;
          case 'w':
            currentFrame = westFrame;
            break;
        }
        [path addObject:[NSValue valueWithCGRect:currentFrame]];
      }
      else
      {
        // backtracking
        NSInteger currentIndex = [path indexOfObject:[NSValue valueWithCGRect:currentFrame]];
        if (currentIndex)
        {
          currentFrame = [[path objectAtIndex:currentIndex -1] CGRectValue];
        }
      }
    }
  } while(!targetFound);
  return path;
}

@end
