//
//  UIColor+MX.m
//  MXToolBox
//
//  Created by mugx on 13/01/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "UIColor+MX.h"

@implementation UIColor (MX)

- (UIImage*)image
{
  CGRect rect = CGRectMake(0, 0, 1, 1);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [self CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return [img stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

@end
