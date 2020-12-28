//
//  TNPlayer.h
//  mmmaze
//
//  Created by mugx on 17/03/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNTile.h"
#import "TNGameSession.h"

#define PLAYER_SPEED 3.0

@interface TNPlayer : TNTile
- (instancetype)initWithFrame:(CGRect)frame withGameSession:(TNGameSession *)gameSession;
@end
