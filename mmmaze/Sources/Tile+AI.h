//
//  Tile+AI.h
//  mmmaze
//
//  Created by mugx on 15/04/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "Tile.h"

@interface Tile (AI)
- (char)getBestDirection:(NSArray *)directions targetFrame:(CGRect)targetFrame;
- (NSArray *)search:(CGRect)target;
@end
