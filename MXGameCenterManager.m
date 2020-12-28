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

- (int64_t)highScore {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_KEY_HIGH_SCORES] firstObject];
}

- (void)saveScore:(int64_t)score
{
	if (score <= 0)
	{
		return;
	}

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

@end
