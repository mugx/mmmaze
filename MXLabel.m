//
//  MXLabel.m
//  MXToolBox
//
//  Created by mugx on 19/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXLabel.h"
#import "MXToolBox.h"

@implementation MXLabel

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.font = [UIFont fontWithName:FONT_FAMILY size:self.font.pointSize];
  
  if (self.mxLocalization)
  {
    self.text = LOCALIZE(self.mxLocalization);
  }
}

@end
