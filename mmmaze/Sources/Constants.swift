//
//  Macros.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
//

import Foundation

enum ScreenType {
    case STMenu
    case STTutorial
    case STNewGame
    case STResumeGame
    case STSettings
    case STHighScores
    case STAchievements
    case STCredits
}

@objc
enum SoundType: UInt {
    case STHitCoin = 1
    case STHitWhirlwind = 2
    case STHitBomb = 3
    case STHitMinion = 4
    case STHitTimeBonus = 5
    case STStartgame = 6
    case STGame = 7
    case STSelectItem = 8
    case STTimeOver = 9
    case STGameOver = 10
    case STLevelChange = 11
    case STEnemySpawn = 12
    case STHitPlayer = 13
}

@objcMembers
class Constants: NSObject {
//    #define GAME_CENTER_ENABLED !DEBUG
    static let FONT_FAMILY = "Joystix"
//    #define TICK NSDate *startTime = [NSDate date]
//    #define TOCK(s) NSLog(s, -[startTime timeIntervalSinceNow])
//    #define RAND(a, b) ((((float) rand()) / (float) RAND_MAX) * (b - a)) +
    static let SOUND_DEFAULT_VOLUME = Float(0.5)
    static let SOUND_ENABLED = true
    static let FEEDBACK_EMAIL = "mugxware@gmail.com"
    static let whiteColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1.0)
    static let greenColor = UIColor(red:0.0/255.0, green:255.0/255.0, blue:0.0/255.0, alpha:1.0)
    static let electricColor = UIColor(red:100.0/255.0, green:0.0/255.0, blue:100.0/255.0, alpha:1.0)
    static let magentaColor = UIColor(red:255.0/255.0, green:0.0/255.0, blue:255.0/255.0, alpha:1.0)
    static let cyanColor = UIColor(red:0.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1.0)
    static let blackColor = UIColor(red:51.0/255.0, green:51.0/255.0, blue:51.0/255.0, alpha:1.0)
    static let yellowColor = UIColor(red:230.0/255.0, green:220.0/255.0, blue:0.0, alpha:1.0)
    static let redColor = UIColor.red
    static let blueColor = UIColor.blue
}

