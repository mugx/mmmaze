//
//  TNPlayer.h
//  mmmaze
//
//  Created by mugx on 17/03/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNTile.h"
#import "GameSession.h"

#define PLAYER_SPEED 3.0

@interface TNPlayer : TNTile
- (instancetype _Nullable )initWithFrame:(CGRect)frame withGameSession:(GameSession *_Nullable)gameSession;
- (void)encodeWithCoder:(nonnull NSCoder *)coder;

+ (nonnull instancetype)appearance;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ...;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes;

+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ...;

+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes;

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection;

- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator;

- (void)setNeedsFocusUpdate;

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context;

- (void)updateFocusIfNeeded;

- (nonnull NSArray<id<UIFocusItem>> *)focusItemsInRect:(CGRect)rect;

@end
