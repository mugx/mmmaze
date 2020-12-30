//
//  Enemy.h
//  mmmaze
//
//  Created by mugx on 23/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "Tile.h"

@interface Enemy : Tile
@property(nonatomic,assign) BOOL wantSpawn;
@property(nonatomic,assign) BOOL exploding;
@property(nonatomic,assign) float upatePathAccumulator;
@property(nonatomic,strong) NSMutableArray *path;
@end

