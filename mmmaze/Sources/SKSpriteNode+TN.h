//
//  UIView+TN.h
//  mmmaze
//
//  Created by mugx on 04/01/2018.
//  Copyright © 2018 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (TN)
- (id) initWithSpriteSheetNamed: (NSString *) spriteSheet withinNode: (SKScene *) scene sourceRect: (CGRect) source andNumberOfSprites: (int) numberOfSprites;
@end
