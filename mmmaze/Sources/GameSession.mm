//
//  GameSession.m
//  mmmaze
//
//  Created by mugx on 10/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "mmmaze-Swift.h"
#import "GameSession.h"
#import "ToolBox.h"
#import "MazeGenerator.hpp"

#define BASE_MAZE_DIMENSION 7

@implementation GameSession

- (instancetype)initWithView:(UIView *)gameView {
	self = [super init];
	_gameView = gameView;
	return self;
}

- (void)startLevel:(NSUInteger)levelNumber {
	self.gameView.alpha = 0;
	
	//--- setup gameplay varables ---//
	self.currentLevel = levelNumber;
	self.currentTime = MAX_TIME;
	self.isGameStarted = NO;
	
	if (levelNumber == 1) {
		//--- play start game sound ---//
		[self playWithSound: SoundTypeStartGame];
		
		self.currentScore = 0;
		self.currentLives = MAX_LIVES;
		self.numCol = BASE_MAZE_DIMENSION;
		self.numRow = BASE_MAZE_DIMENSION;
	} else {
		//--- play start level sound ---//
		[self playWithSound: SoundTypeLevelChange];
	}
	
	//--- reset random rotation ---//
	self.gameView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
	
	//--- remove old views ---//
	for (UIView *view in self.mazeView.subviews) {
		view.hidden = YES;
		[view removeFromSuperview];
	}
	
	//--- init scene elements ---//
	self.numCol = (self.numCol + 2) < 30 ? self.numCol + 2 : self.numCol;
	self.numRow = (self.numRow + 2) < 30 ? self.numRow + 2 : self.numRow;
	[self makeMaze];
	[self makePlayer];
	
	///--- setup collaborator ---//
	self.enemyCollaborator = [[EnemyCollaborator alloc] initWithGameSession: self];
	
	//--- update external delegate ---//
	[self.delegate didUpdateScore:self.currentScore];
	[self.delegate didUpdateLives:self.currentLives];
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.gameView.alpha = 1;
	} completion:^(BOOL finished) {
		[self.delegate didUpdateLevel:self.currentLevel];
	}];
}

- (void)makeMaze {
	self.items = [NSMutableArray array];
	self.mazeView = [[UIView alloc] initWithFrame:self.gameView.frame];
	[self.gameView addSubview:self.mazeView];
	self.mazeRotation = 0;
	self.isGameOver = NO;
	
	//--- generating the maze ---//
	MazeGenerator *mazeGenerator = new MazeGenerator();
	MazeTyleType **maze = mazeGenerator->calculateMaze(static_cast<int>(Constants.STARTING_CELL.x), static_cast<int>(Constants.STARTING_CELL.y), static_cast<int>(self.numCol), static_cast<int>(self.numRow));
	self.wallsDictionary = [NSMutableDictionary dictionary];
	
	NSMutableArray *freeTiles = [NSMutableArray array];
	for (int r = 0; r < self.numRow ; r++)
	{
		for (int c = 0; c < self.numCol; c++)
		{
			if (maze[r][c] == MTWall)
			{
				Tile *tile = [[Tile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
				tile.tag = TTWall;
				[tile setImage:[[UIImage imageNamed:@"wall"] coloredWith:[UIColor whiteColor]]];
				tile.isDestroyable = !(r == 0 || c == 0 || r == self.numRow - 1 || c == self.numCol - 1);
				tile.x = r;
				tile.y = c;
				[self.mazeView addSubview:tile];
				[self.wallsDictionary setObject:tile forKey:[NSValue valueWithCGPoint:CGPointMake(r, c)]];
			}
			else if (maze[r][c] == MTStart)
			{
				Tile *tile = [[Tile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
				tile.x = r;
				tile.y = c;
				tile.tag = TTDoor;
				tile.isDestroyable = NO;
				[self.mazeView addSubview:tile];
				[self.items addObject:tile];
			}
			else if (maze[r][c] == MTEnd)
			{
				Tile *tile = [[Tile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
				tile.x = r;
				tile.y = c;
				tile.tag = TTMazeEnd_close;
				tile.isDestroyable = NO;
				[tile setImage:[UIImage imageNamed:@"gate_close"]];
				[self.mazeView addSubview:tile];
				[self.wallsDictionary setObject:tile forKey:[NSValue valueWithCGPoint:CGPointMake(r, c)]];
				self.mazeGoalTile = tile;
				[self.items addObject:tile];
			}
			else
			{
				Tile *item = [self makeItem:c row:r];
				if (!item)
				{
					[freeTiles addObject:@{@"c":@(c), @"r":@(r)}];
				}
			}
		}
	}
	
	//--- make key ---//
	NSDictionary *keyPosition = freeTiles[arc4random() % freeTiles.count];
	int c = [keyPosition[@"c"] intValue];
	int r = [keyPosition[@"r"] intValue];
	Tile *keyItem = [[Tile alloc] initWithFrame:CGRectMake(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
	keyItem.x = c;
	keyItem.y = r;
	keyItem.tag = TTKey;
	keyItem.image = [[UIImage imageNamed:@"key"] coloredWith:Constants.magentaColor];
	[self.mazeView addSubview:keyItem];
	[self.items addObject:keyItem];
	
	for (int i = 0; i < self.numCol; ++i)
	{
		free(maze[i]);
	}
	free(maze);
}

- (Tile *)makeItem:(int)col row:(int)row
{
	Tile *item = [[Tile alloc] initWithFrame:CGRectMake(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
	item.tag = -1;
	
	if ((arc4random() % 100) >= 50)
	{
		item.tag = TTCoin;
		item.image = [[UIImage imageNamed:@"coin"] coloredWith:[UIColor yellowColor]];
		[item spin];
	}
	else if ((arc4random() % 100) >= 90)
	{
		item.tag = TTWhirlwind;
		item.image = [[UIImage imageNamed:@"whirlwind"] coloredWith:[UIColor whiteColor]];
		[item spin];
	}
	else if ((arc4random() % 100) >= 80)
	{
		item.tag = TTBomb;
		item.image = [[UIImage imageNamed:@"bomb"] coloredWith:Constants.redColor];
	}
	else if ((arc4random() % 100) >= 98)
	{
		item.tag = TTTime;
		item.animationImages = [[UIImage imageNamed:@"time"] spritesWith:CGSizeMake(TILE_SIZE, TILE_SIZE)];
		item.animationDuration = 1;
		[item startAnimating];
	}
	else if ((arc4random() % 100) >= 99)
	{
		int hearthSize = TILE_SIZE;
		item = [[Tile alloc] initWithFrame:CGRectMake(col * hearthSize, row * hearthSize, hearthSize, hearthSize)];
		item.tag = TTHearth;
		item.image = [UIImage imageNamed:@"hearth"];
	}
	
	if (item.tag != -1)
	{
		item.x = col;
		item.y = row;
		[self.mazeView addSubview:item];
		[self.items addObject:item];
		return item;
	}
	else
	{
		return nil;
	}
}

- (void)respawnPlayerAtOrigin:(int)blinkingTime {
	self.player.isBlinking = YES;
	[UIView animateWithDuration:0.4 animations:^{
		[self.player respawnAtInitialFrame];

		self.mazeView.frame = CGRectMake(self.mazeView.frame.size.width / 2.0 - self.player.frame.origin.x, self.mazeView.frame.size.height / 2.0 - self.player.frame.origin.y, self.mazeView.frame.size.width, self.mazeView.frame.size.height);
	} completion:^(BOOL finished) {
		[self.player blink:blinkingTime completion:^{
			self.player.isBlinking = NO;
		}];
	}];
}

- (void)update:(CGFloat)deltaTime
{
	self.currentTime = self.currentTime - deltaTime > 0 ? self.currentTime - deltaTime : 0;
	[self.delegate didUpdateTime:self.currentTime];
	
	//--- hurry up ---//
	if (self.currentTime <= 10)
	{
		[self.delegate didHurryUp];
	}
	
	//--- updating enemies stuff ---//
	if (self.isGameStarted)
	{
		[self.enemyCollaborator update:deltaTime];
	}
	
	//--- checking walls collisions ---//
	if (!self.isGameOver)
	{
		[self.player update:deltaTime];
	}
	
	//--- checking items collisions ---//
	NSMutableArray *itemsToRemove = [NSMutableArray array];
	for (Tile *item in self.items)
	{
		if (CGRectIntersectsRect(item.frame, self.player.frame))
		{
			if (item.tag == TTCoin)
			{
				[self playWithSound: SoundTypeHitCoin];
				item.hidden = true;
				[itemsToRemove addObject:item];
				self.currentScore += 15;
				[self.delegate didUpdateScore:self.currentScore];
			}
			else if (item.tag == TTWhirlwind)
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
			else if (item.tag == TTTime)
			{
				[self playWithSound: SoundTypeHitTimeBonus];
				item.hidden = true;
				[itemsToRemove addObject:item];
				self.currentTime += 5;
			}
			else if (item.tag == TTKey)
			{
				[self playWithSound: SoundTypeHitHearth];
				item.hidden = true;
				[itemsToRemove addObject:item];
				self.mazeGoalTile.tag = TTMazeEnd_open;
				[self.mazeGoalTile setImage:[UIImage imageNamed:@"gate_open"]];
				[self.wallsDictionary removeObjectForKey:[NSValue valueWithCGPoint:CGPointMake(self.mazeGoalTile.x, self.mazeGoalTile.y)]];
			}
			else if (item.tag == TTHearth)
			{
				[self playWithSound: SoundTypeHitHearth];
				item.hidden = true;
				[itemsToRemove addObject:item];
				++self.currentLives;
				[self.delegate didUpdateLives:self.currentLives];
			}
			else if (item.tag == TTBomb)
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
						tile.tag = TTExplodedWall;
					}
					else if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x - TILE_SIZE, player_y, TILE_SIZE, TILE_SIZE)))
					{
						[tile explode:nil];
						tile.tag = TTExplodedWall;
					}
					
					if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x, player_y + TILE_SIZE, TILE_SIZE, TILE_SIZE)))
					{
						[tile explode:nil];
						tile.tag = TTExplodedWall;
					}
					
					if (tile.isDestroyable && CGRectIntersectsRect(tile.frame, CGRectMake(player_x, player_y - TILE_SIZE, TILE_SIZE, TILE_SIZE)))
					{
						[tile explode:nil];
						tile.tag = TTExplodedWall;
					}
				}
			}
		}
		else
		{
			if (item.tag == TTBomb)
			{
				for (Enemy *enemy in self.enemyCollaborator.enemies)
				{
					if (CGRectIntersectsRect(enemy.frame, item.frame))
					{
						item.hidden = true;
						[itemsToRemove addObject:item];
						enemy.wantSpawn = YES;
						[self playWithSound: SoundTypeEnemySpawn];
						break;
					}
				}
			}
		}
		item.transform = CGAffineTransformMakeRotation(-self.mazeRotation);
	}
	[self.items removeObjectsInArray:itemsToRemove];
	
	//--- updating maze frame ---//
	self.mazeView.frame = CGRectMake(self.mazeView.frame.size.width / 2.0 - self.player.frame.origin.x, self.mazeView.frame.size.height / 2.0 - self.player.frame.origin.y, self.mazeView.frame.size.width, self.mazeView.frame.size.height);
	
	///--- collision player vs enemies ---//
	for (Enemy *enemy in self.enemyCollaborator.enemies)
	{
		if (!self.player.isBlinking && self.currentLives > 0 && CGRectIntersectsRect(enemy.frame, self.player.frame))
		{
			if (!self.player.isAngry)
			{
				[self playWithSound: SoundTypeHitPlayer];
				enemy.wantSpawn = YES;
				self.currentLives = self.currentLives - 1;
				[self.delegate didUpdateLives:self.currentLives];
				if (self.currentLives > 0) {
					[self respawnPlayerAtOrigin:2];
				}
			}
			else
			{
				[UIView animateWithDuration:0.4 animations:^{
					[enemy respawnAtInitialFrame];
				} completion:^(BOOL finished) {
					self.player.isAngry = NO;
				}];
			}
			break;
		}
	}
	
	//--- collision player vs maze goal---//
	if (self.mazeGoalTile.tag == TTMazeEnd_open  && CGRectIntersectsRect(self.player.frame, self.mazeGoalTile.frame))
	{
		[self startLevel:self.currentLevel + 1];
		self.currentScore += 100;
	}
	
	//--- collision if player is dead---//
	if (!self.isGameOver && (self.currentLives == 0 || self.currentTime <= 0))
	{
		self.isGameOver = YES;
		[self playWithSound: SoundTypeGameOver];
		[self.player explode:^{
			[self.delegate performSelector:@selector(didGameOver:) withObject:self];
		}];
	}
}
@end
