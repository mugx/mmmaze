//
//  MXGameCenterManager.h
//  MXToolBox
//
//  Created by mugx on 06/06/14.
//  Copyright (c) 2014 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#define SAVE_KEY_HIGH_SCORES @"highScores"
#define MAX_HIGH_SCORES_COUNT 10

@interface MXGameCenterManager : NSObject <GKGameCenterControllerDelegate>
+ (instancetype)sharedInstance;
- (void)saveScore:(int64_t)score;
- (int64_t)highScore;
@end
