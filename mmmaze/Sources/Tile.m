//
//  Tile.m
//  mmmaze
//
//  Created by mugx on 29/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import "Tile.h"
#import "mmmaze-Swift.h"

@implementation Tile

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	_animations = [NSMutableDictionary dictionary];
	return self;
}

@end
