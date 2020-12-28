//
//  MXButton.m
//  MXToolBox
//
//  Created by mugx on 19/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXButton.h"
#import "UIImage+MX.h"
#import "MXToolBox.h"

@implementation MXButton

- (void)awakeFromNib
{
  [super awakeFromNib];

  self.titleLabel.font = [UIFont fontWithName:FONT_FAMILY size:self.titleLabel.font.pointSize];
  if (self.mxLocalization)
  {
    [self setTitle:LOCALIZE(self.mxLocalization) forState:UIControlStateNormal];
  }
  self.titleLabel.adjustsFontSizeToFitWidth = YES;

  if (self.mxImageColor)
  {
    [self setImage:[self.imageView.image imageColored:self.mxImageColor] forState:UIControlStateNormal];
  }
}

@end
