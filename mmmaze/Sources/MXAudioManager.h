//
//  MXAudioManager.h
//  MXAudioManager v1.0.2
//
//  Created by mugx on 07/01/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double MXAudioManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char MXAudioManagerVersionString[];

@interface MXAudioManager : NSObject

/**
 @brief The shared instance of the MXAudioManager
 @return return the instance of this class.
 */
+ (instancetype)sharedInstance;

/*!
 @brief load sounds and background musics from a json dictionary
 @param audioDictionary is the json dictionary, the structure should follow this schema, eg:
 . "audio":{
 .         "backgroundMusic":[
 .               {"name":"bckg1.mp3", "id":"0"},
 .               {"name":"bckg2.mp3", "id":"1"}],
 .         "sounds":[
 .               {"name":"sound1.caff", "id":"2"},
 .               {"name":"sound1.caff", "id":"3"}]
 . }
 */
- (void)load:(NSDictionary *)audioDictionary;

/*!
 @brief load a background music given a file name and the audioID
 @param fileName the sound file name (eg: @"backgroundMusicFoo.caf")
 @param audioID useful to interact with the background music (eg: MyBackgroundMusicType1)
 @return true if the background music was loaded, false otherwise
 */
- (BOOL)loadBackgroundMusic:(NSString *)fileName withID:(NSUInteger)audioID;

/*!
 @brief load a sound given a file name and the audioID
 @param fileName the sound file name (eg: @"soundFoo.caf")
 @param audioID useful to interact with the sound (eg: MySoundType1)
 @return true if the sound was loaded, false otherwise
 */
- (BOOL)loadSound:(NSString *)fileName withID:(NSUInteger)audioID;

/*!
 @brief unload all the sounds and background musics
 */
- (void)unload;

/*!
 @brief unload a sound/music given the audioID
 @param audioID previously loaded recognizes the sound/music to unload.
 */
- (void)unload:(NSUInteger)audioID;

/*!
 @brief play a sound/music given the soundID
 @param audioID previously loaded recognizes the sound/music to play.
 */
- (void)play:(NSUInteger)audioID;

/*!
 @brief stop a sound/music given the audioID
 @param audioID previously loaded recognizes the sound/music to stop.
 */
- (void)stop:(NSUInteger)audioID;

/*
 @brief the volume property has a range between 1 and 0 and can be modified in order to change all the sounds volume
 */
@property(nonatomic,assign) float volume;

/*!
 @brief soundEnabled can be switched in order to mute/unmute the audio manager
 */
@property(nonatomic,assign) BOOL soundEnabled;
@end
