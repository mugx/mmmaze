//
//  GameSession.m
//  mmmaze
//
//  Created by mugx on 10/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "mmmaze-Swift.h"
#import "GameSession.h"

@implementation GameSession

- (instancetype)initWithView:(UIView *)gameView {
	self = [super init];
	_gameView = gameView;
	return self;
}

- (void)update:(CGFloat)deltaTime {
	if (self.isGameOver) { return; }

	[self updateWithDelta: deltaTime];
	
	//--- checking items collisions ---//
	NSMutableArray *itemsToRemove = [NSMutableArray array];
	for (Tile *item in self.items) {
		if (CGRectIntersectsRect(item.frame, self.player.frame))
		{
			if (item.tag == TyleTypeCoin)
			{
				[self playWithSound: SoundTypeHitCoin];
				item.hidden = true;
				[itemsToRemove addObject:item];
				self.currentScore += 15;
				[self.delegate didUpdateScore:self.currentScore];
			}
			else if (item.tag == TyleTypeWhirlwind)
			{
				[self playWithSound: SoundTypeHitWhirlwind];
				item.hidden = true;
				[itemsToRemove addObject:item];
				
				[UIView animateWithDuration:0.2 animations:^{
					self.mazeRotation += M_PI_2;
					self.gameView.transform = CGAffineTransformRotate(self.gameView.transform, M_PI_2);
					self.player.transform = CGAffineTransformMakeRotation(-self.mazeRotation);
				}];
			}
			else if (item.tag == TyleTypeTime)
			{
				[self playWithSound: SoundTypeHitTimeBonus];
				item.hidden = true;
				[itemsToRemove addObject:item];
				self.currentTime += 5;
			}
			else if (item.tag == TyleTypeKey)
			{
				[self playWithSound: SoundTypeHitHearth];
				item.hidden = true;
				[itemsToRemove addObject:item];
				self.mazeGoalTile.tag = TyleTypeMazeEnd_open;
				[self.mazeGoalTile setImage:[UIImage imageNamed:@"gate_open"]];
				[self.wallsDictionary removeObjectForKey:[NSValue valueWithCGPoint:CGPointMake(self.mazeGoalTile.x, self.mazeGoalTile.y)]];
			}
			else if (item.tag == TyleTypeHearth)
			{
				[self playWithSound: SoundTypeHitHearth];
				item.hidden = true;
				[itemsToRemove addObject:item];
				++self.currentLives;
				[self.delegate didUpdateLives:self.currentLives];
			}
			else if (item.tag == TyleTypeBomb)
			{
				[self playWithSound: SoundTypeHitBomb];
				item.hidden = true;
				[itemsToRemove addObject:item];
				int player_x = (int)self.player.frame.origin.x;
				int player_y = (int)self.player.frame.origin.y;
				self.player.isAngry = YES;
				
				for (Tile *tile in [self.wallsDictionary allValues])
				{
					if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x + TILE_SIZE, player_y, TILE_SIZE, TILE_SIZE)))
					{
						[tile explode:nil];
						tile.tag = TyleTypeExplodedWall;
					}
					else if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x - TILE_SIZE, player_y, TILE_SIZE, TILE_SIZE)))
					{
						[tile explode:nil];
						tile.tag = TyleTypeExplodedWall;
					}
					
					if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x, player_y + TILE_SIZE, TILE_SIZE, TILE_SIZE)))
					{
						[tile explode:nil];
						tile.tag = TyleTypeExplodedWall;
					}
					
					if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x, player_y - TILE_SIZE, TILE_SIZE, TILE_SIZE)))
					{
						[tile explode:nil];
						tile.tag = TyleTypeExplodedWall;
					}
				}
			}
		}
		else
		{
			if (item.tag == TyleTypeBomb) {
				[self.enemyCollaborator collideWith: item completion:^(Enemy *enemy) {
					item.hidden = true;
					[itemsToRemove addObject:item];
					enemy.wantSpawn = YES;
					[self playWithSound: SoundTypeEnemySpawn];
				}];
			}
		}
		item.transform = CGAffineTransformMakeRotation(-self.mazeRotation);
	}
	[self.items removeObjectsInArray:itemsToRemove];
}

@end
