//
//  MXLocalizationManager.h
//  MXToolBox
//
//  Created by mugx on 28/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MXLocalizationManager : NSObject
+ (instancetype)sharedInstance;
- (NSString *)localize:(NSString *)localizationKey;
- (NSArray *)availableLanguages;
@property(nonatomic,copy) NSString *currentLanguageCode;
@end
