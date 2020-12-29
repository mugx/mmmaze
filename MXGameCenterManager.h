//
//  MXGameCenterManager.h
//  MXToolBox
//
//  Created by mugx on 06/06/14.
//  Copyright (c) 2014 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAVE_KEY_HIGH_SCORES @"highScores"
#define MAX_HIGH_SCORES_COUNT 10

@interface MXGameCenterManager : NSObject
+ (instancetype)sharedInstance;
- (void)saveScore:(int64_t)score;
@end
