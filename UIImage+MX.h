//
//  UIImage+MX.h
//  MXToolBox
//
//  Created by mugx on 26/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MX)
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)imageColored:(UIColor *)color;
- (UIImage*)scale:(CGFloat)newHeight;
- (NSArray *)spritesWithSize:(CGSize)size inRange:(NSRange)range;
@end
