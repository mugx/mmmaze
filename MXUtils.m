//
//  MXUtils.m
//  MXToolBox
//
//  Created by mugx on 15/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXUtils.h"

@implementation MXUtils

+ (id)jsonFromFile:(NSString *)fileName
{
  NSData *gameData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]]];
  return [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableContainers error:nil];
}

@end
