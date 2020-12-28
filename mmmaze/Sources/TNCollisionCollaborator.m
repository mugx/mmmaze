//
//  TNCollisionCollaborator.m
//  mmmaze
//
//  Created by mugx on 18/03/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "TNCollisionCollaborator.h"
#import "TNPlayer.h"

@interface TNCollisionCollaborator()
@property(nonatomic,weak) TNGameSession *gameSession;
@end

@implementation TNCollisionCollaborator

- (instancetype)init:(TNGameSession *)gameSession
{
  self = [super init];
  _gameSession = gameSession;
  return self;
}

- (void)update:(CGFloat)deltaTime
{
}

@end
