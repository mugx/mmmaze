//
//  MXGameCenterManager.m
//  MXToolBox
//
//  Created by mugx on 06/06/14.
//  Copyright (c) 2014 mugx. All rights reserved.
//

#import "MXGameCenterManager.h"

@interface MXGameCenterManager ()
@property(nonatomic,strong) NSString *leaderboardIdentifier;
@property(nonatomic,strong) NSMutableDictionary *achievementsDictionary;
@end

@implementation MXGameCenterManager

+ (instancetype)sharedInstance
{
  static MXGameCenterManager *gameSettings = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gameSettings = [[self alloc] init];
  });
  return gameSettings;
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController
{
  [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)authenticateLocalPlayer:(void (^)(BOOL isEnabled))completion
{
  /*
   if (!GAME_CENTER_ENABLED)
   {
   return;
   }
   */
  
  [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error)
  {
    if (viewController != nil)
    {
      [[[UIApplication sharedApplication] delegate].window.rootViewController presentViewController:viewController animated:YES completion:nil];
      if (completion) completion(self.gameCenterEnabled);
    }
    else
    {
      if ([GKLocalPlayer localPlayer].authenticated)
      {
        // loading leaderboard
        [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error)
         {
           if (error != nil)
           {
             NSLog(@"%@", [error localizedDescription]);
           }
           else
           {
             self.gameCenterEnabled = YES;
             self.leaderboardIdentifier = leaderboardIdentifier;
             if (completion) completion(self.gameCenterEnabled);
             
             GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
             if (leaderboardRequest != nil)
             {
               leaderboardRequest.identifier = self.leaderboardIdentifier;
               [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray<GKScore *> *scores, NSError *error) {
                 if (error == nil && scores && scores.count > 0)
                 {
                   GKScore *highestScore = [scores objectAtIndex:0];
                   self.highestScore = highestScore.value;
                 }
               }];
             }
           }
         }];
        
        // loading achievements
        //[self loadAchievements];
      }
      else
      {
        self.gameCenterEnabled = NO;
        if (completion) completion(self.gameCenterEnabled);
      }
    }
  };
}

- (void)saveScore:(int64_t)score
{
  if (score <= 0)
  {
    return;
  }
  
  if (self.gameCenterEnabled)
  {
    GKScore *leaderboardSore = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardIdentifier];
    leaderboardSore.value = score;
    
    [GKScore reportScores:@[leaderboardSore] withCompletionHandler:^(NSError *error)
     {
       if (error != nil)
       {
         NSLog(@"%@", [error localizedDescription]);
       }
     }];
  }
  else
  {
    NSMutableArray *highScores = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:SAVE_KEY_HIGH_SCORES]];
    [highScores addObject:[NSNumber numberWithLongLong:score]];
    highScores = [NSMutableArray arrayWithArray:[highScores sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"self" ascending: NO]]]];
    if (highScores.count > MAX_HIGH_SCORES_COUNT)
    {
      [highScores removeObjectAtIndex:highScores.count - 1];
    }
    [[NSUserDefaults standardUserDefaults] setObject:highScores forKey:SAVE_KEY_HIGH_SCORES];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

#pragma mark - Achievements

- (void)loadAchievements
{
  self.achievementsDictionary = [[NSMutableDictionary alloc] init];
  [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
    if (error != nil)
    {
      // Handle the error.
      NSLog(@"Error while loading achievements: %@", error.description);
    }
    else if (achievements != nil)
    {
      // Process the array of achievements.
      for (GKAchievement* achievement in achievements)
      {
        self.achievementsDictionary[achievement.identifier] = achievement;
      }
    }
  }];
}

- (void)saveAchievement:(NSString *)achievementID
{
  
  GKAchievement *achievement = [self.achievementsDictionary objectForKey:achievementID];
  if (achievement == nil)
  {
    achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
    self.achievementsDictionary[achievement.identifier] = achievement;
  }
  
  if (achievement && achievement.percentComplete != 100.0) {
    achievement.percentComplete = 100;
    achievement.showsCompletionBanner = YES;
    
    [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
      if (error != nil) {
        NSLog(@"Error while reporting achievement: %@", error.description);
      }
    }];
  }
}

- (void)resetAchievements
{
  // Clear all locally saved achievement objects.
  self.achievementsDictionary = [[NSMutableDictionary alloc] init];
  
  // Clear all progress saved on Game Center.
  [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
   {
     if (error != nil) {
       // handle the error.
       NSLog(@"Error while reseting achievements: %@", error.description);
       
     }
   }];
}

- (void)showLeaderboard
{
  GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
  gcViewController.gameCenterDelegate = self;
  gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
  gcViewController.leaderboardIdentifier = self.leaderboardIdentifier;
  gcViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  gcViewController.modalPresentationStyle = UIModalPresentationFormSheet;
  [[[UIApplication sharedApplication] delegate].window.rootViewController presentViewController:gcViewController animated:YES completion:nil];
}

- (void)showAchievements
{
  GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
  gcViewController.gameCenterDelegate = self;
  gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
  [[[UIApplication sharedApplication] delegate].window.rootViewController presentViewController:gcViewController animated:YES completion:nil];
}

@end
