//
//  MXAudioManager.m
//  MXAudioManager
//
//  Created by mugx on 07/01/16.
//  Copyright © 2016 mugx. All rights reserved.
//
//  http://www.raywenderlich.com/69369/audio-tutorial-ios-playing-audio-programatically-2014-edition
//  http://blog.spacemanlabs.com/2011/08/integers-in-your-collections-nsnumbers-not-my-friend/

#import "MXAudioManager.h"
#import "MXOpenALSupport.h"

#define kAudio @"audio"
#define kBackgroundMusic @"backgroundMusic"
#define kSounds @"sounds"

typedef struct
{
  const char *url;
  NSUInteger audioID;
  ALuint source;
  ALuint buffer;
} SystemSound;

@interface MXAudioManager()
@property(nonatomic,assign) ALCcontext *context;
@property(nonatomic,assign) ALCdevice *device;
@property(nonatomic,assign) CFMutableDictionaryRef soundsDictionary;
@end

@implementation MXAudioManager

+ (instancetype)sharedInstance
{
  static dispatch_once_t predicate;
  static MXAudioManager *instance = 0;
  dispatch_once(&predicate, ^{
    instance = [MXAudioManager new];
  });
  return instance;
}

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    _soundsDictionary = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    _soundEnabled = YES;
    _volume = 0.5;
    //[self initOpenALContext];
  }
  return self;
}

- (void)initOpenALContext
{
//  _device = alcOpenDevice(NULL);
//  _context = alcCreateContext(_device, 0);
//  alcMakeContextCurrent(_context);
//  alGetError();
}

- (void)dealloc
{
  alcDestroyContext(_context);
  alcCloseDevice(_device);
  
  CFIndex countSounds = CFDictionaryGetCount(_soundsDictionary);
  void *valuesSounds[countSounds];
  CFDictionaryGetKeysAndValues(_soundsDictionary, NULL, (void *)valuesSounds);
  for (CFIndex i = 0; i < countSounds;++i)
  {
    SystemSound *systemSound = (SystemSound *)valuesSounds[i];
    alDeleteSources(1, &systemSound->source);
    alDeleteBuffers(1, &systemSound->buffer);
    free(systemSound);
  }
  
  if (_soundsDictionary)
  {
    CFRelease(_soundsDictionary);
  }
}

#pragma mark - Public Functions
- (void)load:(NSDictionary *)dictionary
{
  NSDictionary *audioDictionary = dictionary[kAudio];
  
  //--- load background music ---//
  NSArray *backgroundMusicsDictionary = audioDictionary[kBackgroundMusic];
  for (NSDictionary *backgroundMusicDictionary in backgroundMusicsDictionary)
  {
    NSString *backgroundMusicName = backgroundMusicDictionary[@"name"];
    NSString *backgroundMusicID = backgroundMusicDictionary[@"id"];
    [self loadBackgroundMusic:backgroundMusicName withID:[backgroundMusicID intValue]];
  }
  
  //--- load sounds ---//
  NSArray *soundsDictionary = audioDictionary[kSounds];
  for (NSDictionary *soundDictionary in soundsDictionary)
  {
    NSString *soundName = soundDictionary[@"name"];
    NSString *soundID = soundDictionary[@"id"];
    [self loadSound:soundName withID:[soundID intValue]];
  }
}

- (BOOL)loadSound:(NSString *)fileName withID:(NSUInteger)audioID
{
  NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
  if (!path)
  {
   return NO;
  }
  
  NSURL *fileURL = [NSURL fileURLWithPath:path];
  if (fileURL)
  {
    SystemSound *systemSound = malloc(sizeof(SystemSound));
    systemSound->url = [fileName UTF8String];
    systemSound->audioID = audioID;
    systemSound->buffer = MakeOpenALBuffer((__bridge CFURLRef)fileURL);
    
    alGenSources(1, &systemSound->source);
    alSourcei(systemSound->source, AL_LOOPING, AL_FALSE);
    alSourcef(systemSound->source, AL_GAIN, self.volume);
    alSourcei(systemSound->source, AL_BUFFER, systemSound->buffer);
    
    SystemSound *systemSoundCached = (SystemSound *) CFDictionaryGetValue(_soundsDictionary, (void *)audioID);
    if (systemSoundCached)
    {
      [self unload:audioID];
    }
    CFDictionarySetValue(_soundsDictionary, (void *)audioID, (void *)systemSound);
    
    return YES;
  }
  else
  {
    return NO;
  }
}

- (BOOL)loadBackgroundMusic:(NSString *)fileName withID:(NSUInteger)audioID
{
  if ([self loadSound:fileName withID:audioID])
  {
    SystemSound *systemSound = (SystemSound *)CFDictionaryGetValue(_soundsDictionary, (void *)audioID);
    if (systemSound)
    {
      alSourcei(systemSound->source, AL_LOOPING, AL_TRUE);
      return YES;
    }
  }
  return NO;
}

- (void)unload
{
  CFIndex countSounds = CFDictionaryGetCount(_soundsDictionary);
  void *valuesSounds[countSounds];
  CFDictionaryGetKeysAndValues(_soundsDictionary, NULL, (void *)valuesSounds);
  for (CFIndex i = 0; i < countSounds;++i)
  {
    SystemSound *systemSound = (SystemSound *)valuesSounds[i];
    alDeleteSources(1, &systemSound->source);
    alDeleteBuffers(1, &systemSound->buffer);
    free(systemSound);
  }
  CFDictionaryRemoveAllValues(_soundsDictionary);
}

- (void)unload:(NSUInteger)audioID
{
  SystemSound *systemSound = (SystemSound *) CFDictionaryGetValue(_soundsDictionary, (void *)audioID);
  if (systemSound)
  {
    alDeleteSources(1, &systemSound->source);
    alDeleteBuffers(1, &systemSound->buffer);
    
    free(systemSound);
    systemSound = 0;
    CFDictionaryRemoveValue(_soundsDictionary, (void *)audioID);
    return;
  }
}

- (void)play:(NSUInteger)audioID
{
  if (self.soundEnabled)
  {
    SystemSound *systemSound = (SystemSound *)CFDictionaryGetValue(_soundsDictionary, (void *)audioID);
    if (systemSound)
    {
      alSourcePlay(systemSound->source);
      return;
    }
  }
}

- (void)stop:(NSUInteger)audioID
{
  SystemSound *systemSound = (SystemSound *) CFDictionaryGetValue(_soundsDictionary, (void *)audioID);
  if (systemSound)
  {
    alSourceStop(systemSound->source);
    return;
  }
}

- (void)setVolume:(float)volume
{
  _volume = volume > 1 ? 1 : volume;
  _volume = volume < 0 ? 0 : volume;
  
  CFIndex countSounds = CFDictionaryGetCount(_soundsDictionary);
  void *valuesSounds[countSounds];
  CFDictionaryGetKeysAndValues(_soundsDictionary, NULL, (void *)valuesSounds);
  for (CFIndex i = 0; i < countSounds;++i)
  {
    SystemSound *systemSound = (SystemSound *)valuesSounds[i];
    alSourcef(systemSound->source, AL_GAIN, _volume);
  }
}

- (void)decrementVolume
{
  self.volume = self.volume - 0.1 >= 0 ? self.volume - 0.1 : self.volume;
  
  CFIndex countSounds = CFDictionaryGetCount(_soundsDictionary);
  void *valuesSounds[countSounds];
  CFDictionaryGetKeysAndValues(_soundsDictionary, NULL, (void *)valuesSounds);
  for (CFIndex i = 0; i < countSounds;++i)
  {
    SystemSound *systemSound = (SystemSound *)valuesSounds[i];
    alSourcef(systemSound->source, AL_GAIN, self.volume);
  }
}

#pragma mark - Overriding Properties

- (void)setSoundEnabled:(BOOL)soundEnabled
{
  _soundEnabled = soundEnabled;
  
  CFIndex countSounds = CFDictionaryGetCount(_soundsDictionary);
  void *valuesSounds[countSounds];
  CFDictionaryGetKeysAndValues(_soundsDictionary, NULL, (void *)valuesSounds);
  for (CFIndex i = 0; i < countSounds;++i)
  {
    SystemSound *systemSound = (SystemSound *)valuesSounds[i];
    if (systemSound)
    {
      alSourcePause(systemSound->source);
    }
  }
}

@end
