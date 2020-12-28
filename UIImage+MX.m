//
//  UIImage+MX.m
//  MXToolBox
//
//  Created by mugx on 26/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "UIImage+MX.h"

@implementation UIImage (MX)

- (UIImage *)crop:(CGRect)rect
{
  UIGraphicsBeginImageContextWithOptions(rect.size, false, [self scale]);
  CGPoint drawPoint = CGPointMake(-rect.origin.x, -rect.origin.y);
  [self drawAtPoint:drawPoint];
  UIImage* croppedIMage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return croppedIMage;
}

- (UIImage *)imageColored:(UIColor *)color
{
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  [color setFill];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0, self.size.height);
  CGContextScaleCTM(context, 1.0, -1.0);
  CGContextSetBlendMode(context, kCGBlendModeNormal);
  CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
  CGContextClipToMask(context, rect, self.CGImage);
  CGContextFillRect(context, rect);
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage*)scale:(CGFloat)newHeight
{
  CGFloat newWidth = self.size.width * newHeight / self.size.height;
  CGSize newSize = CGSizeMake(newWidth, newHeight);
  UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
  [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (NSArray *)spritesWithSize:(CGSize)size inRange:(NSRange)range
{
  if (CGSizeEqualToSize(size, CGSizeZero) || range.length == 0)
  {
    return nil;
  }
  
  CGImageRef spriteSheet = [self CGImage];
  NSMutableArray *tempArray = [[NSMutableArray alloc] init];
  
  NSUInteger width = CGImageGetWidth(spriteSheet);
  NSUInteger height = CGImageGetHeight(spriteSheet);
  
  int maxI = width / size.width;
  
  NSUInteger startI = 0;
  NSUInteger startJ = 0;
  NSUInteger length = 0;
  
  NSUInteger startPosition = range.location;
  
  // Extracting initial I & J values from range info
  if (startPosition != 0)
  {
    for (int k=1; k<=maxI; k++)
    {
      int d = k * maxI;
      
      if (d/startPosition == 1)
      {
        startI = maxI - (d % startPosition);
        break;
      }
      else if (d/startPosition > 1)
      {
        startI = startPosition;
        break;
      }
      
      startJ++;
    }
  }
  
  int positionX = startI * size.width;
  int positionY = startJ * size.height;
  BOOL isReady = NO;
  
  while (positionY < height)
  {
    while (positionX < width)
    {
      CGImageRef sprite = CGImageCreateWithImageInRect(spriteSheet, CGRectMake(positionX, positionY, size.width, size.height));
      [tempArray addObject:[UIImage imageWithCGImage:sprite]];
      CGImageRelease(sprite);
      length++;
      
      if (length == range.length)
      {
        isReady = YES;
        break;
      }
      
      positionX += size.width;
    }
    
    if (isReady) break;
    
    positionX = 0;
    positionY += size.height;
  }
  
  return [NSArray arrayWithArray:tempArray];
}

@end
