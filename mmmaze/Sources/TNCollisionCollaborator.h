//
//  TNCollisionCollaborator.h
//  mmmaze
//
//  Created by mugx on 18/03/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TNGameSession;

@interface TNCollisionCollaborator : NSObject
- (instancetype)init:(TNGameSession *)gameSession;
- (void)update:(CGFloat)deltaTime;
@end
