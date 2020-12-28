//
//  UIView+TN.m
//  mmmaze
//
//  Created by mugx on 04/01/2018.
//  Copyright © 2018 mugx. All rights reserved.
//

#import "SKSpriteNode+TN.h"

@implementation SKSpriteNode (TN)

- (id) initWithSpriteSheetNamed: (NSString *) spriteSheet withinNode: (SKScene *) scene sourceRect: (CGRect) source andNumberOfSprites: (int) numberOfSprites {
	
	// @param numberOfSprites - the number of sprite images to the left
	// @param scene - I add my sprite to a map node. Change it to a SKScene
	// if [self addChild:] is used.
	
	NSMutableArray *mAnimatingFrames = [NSMutableArray array];
	
	SKTexture  *ssTexture = [SKTexture textureWithImageNamed:spriteSheet];
	// Makes the sprite (ssTexture) stay pixelated:
	ssTexture.filteringMode = SKTextureFilteringNearest;
	
	float sx = source.origin.x;
	float sy = source.origin.y;
	float sWidth = source.size.width;
	float sHeight = source.size.height;
	
	// IMPORTANT: textureWithRect: uses 1 as 100% of the sprite.
	// This is why division from the original sprite is necessary.
	// Also why sx is incremented by a fraction.
	
	for (int i = 0; i < numberOfSprites; i++) {
		CGRect cutter = CGRectMake(sx, sy/ssTexture.size.width, sWidth/ssTexture.size.width, sHeight/ssTexture.size.height);
		SKTexture *temp = [SKTexture textureWithRect:cutter inTexture:ssTexture];
		[mAnimatingFrames addObject:temp];
		sx+=sWidth/ssTexture.size.width;
	}
	
	self = [SKSpriteNode spriteNodeWithTexture:mAnimatingFrames[0]];
	

	//animatingFrames = mAnimatingFrames;
	
	[scene addChild:self];
	[self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:mAnimatingFrames timePerFrame:0.25]]];
	return self;
}

@end
