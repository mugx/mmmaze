//
//  MXImageView.m
//  MXToolBox
//
//  Created by mugx on 17/12/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXImageView.h"
#import "UIImage+MX.h"

@implementation MXImageView

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  if (self.mxImageColor)
  {
    [self setImage:[self.image imageColored:self.mxImageColor]];
  }
}

@end
