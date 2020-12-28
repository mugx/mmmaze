//
//  MXLocalizationManager.m
//  MXToolBox
//
//  Created by mugx on 28/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXLocalizationManager.h"

#define kLanguageCode @"languageCode"

@interface MXLocalizationManager()
@property(nonatomic,strong) NSMutableDictionary *localizationDictionary;
@end

@implementation MXLocalizationManager

+ (instancetype)sharedInstance
{
  static MXLocalizationManager *instance;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    instance = [[MXLocalizationManager alloc] init];
  });
  return instance;
}

- (instancetype)init
{
  if (self = [super init])
  {
    _localizationDictionary = [NSMutableDictionary dictionary];
    [self setDefaultCurrentLanguage];
  }
  return self;
}

#pragma mark - Public functions

- (NSString *)localize:(NSString *)localizationKey
{
  NSString *localizedString = self.localizationDictionary[localizationKey];
  if (!localizedString)
  {
    localizedString = localizationKey;
  }
  return localizedString;
}

- (NSString *)currentLanguageCode
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageCode];
}

- (void)setCurrentLanguageCode:(NSString *)currentLanguageCode
{
  [[NSUserDefaults standardUserDefaults] setObject:currentLanguageCode forKey:kLanguageCode];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self refreshLocalizations:currentLanguageCode];
}

- (NSArray *)availableLanguages
{
  NSArray *object = [[NSBundle mainBundle] localizations];
  if (!object || object.count == 0)
  {
    for (NSBundle *bundle in [NSBundle allBundles])
    {
      if (bundle)
      {
        NSArray *otherObject = [bundle localizations];
        if (otherObject && otherObject.count > 1)
        {
          object = otherObject;
          break;
        }
      }
    }
  }
  return object;
}

#pragma mark - Private functions

- (void)setDefaultCurrentLanguage
{
  NSString *languageCode = [self currentLanguageCode];
  if (!languageCode)
  {
    languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    if ([languageCode containsString:@"-"])
    {
      NSArray *components = [languageCode componentsSeparatedByString:@"-"];
      if (components.count > 1)
      {
        languageCode = components[0];
      }
    }
    
    if (![[self availableLanguages] containsObject:languageCode])
    {
      languageCode = [self defaultLanguageCode];
    }
    
    [self setCurrentLanguageCode:languageCode];
  }
  else
  {
    [self refreshLocalizations:languageCode];
  }
}

- (NSString *)defaultLanguageCode
{
  return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleDevelopmentRegionKey];
}

- (void)refreshLocalizations:(NSString *)languageCode
{
  self.localizationDictionary = [NSMutableDictionary dictionary];
  NSString *directoryLproj = [NSString stringWithFormat:@"%@.lproj", languageCode];
  NSMutableArray *localizablePathArray = [NSMutableArray arrayWithArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"strings" inDirectory:directoryLproj]];
  for (NSBundle *frameworkBundle in [NSBundle allFrameworks])
  {
    [localizablePathArray addObjectsFromArray:[frameworkBundle pathsForResourcesOfType:@"strings" inDirectory:directoryLproj]];
  }
  
  for (NSBundle *bundle in [NSBundle allBundles])
  {
    [localizablePathArray addObjectsFromArray:[bundle pathsForResourcesOfType:@"strings" inDirectory:directoryLproj]];
  }
  
  for (NSString *path in localizablePathArray)
  {
    [self.localizationDictionary addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
  }
}

@end
