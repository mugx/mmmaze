//
//  Macros.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import Foundation

enum ScreenType {
	case STMenu
	case STTutorial
	case STNewGame
	case STResumeGame
	case STSettings
	case STHighScores
	case STCredits
}

@objcMembers
class Constants: NSObject {
	static let STARTING_CELL = CGPoint(x: 1, y: 1)
	static let FONT_FAMILY = "Joystix"
	static let whiteColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1.0)
	static let magentaColor = UIColor(red:255.0/255.0, green:0.0/255.0, blue:255.0/255.0, alpha:1.0)
	static let cyanColor = UIColor(red:0.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1.0)
	static let yellowColor = UIColor(red:230.0/255.0, green:220.0/255.0, blue:0.0, alpha:1.0)
	static let redColor = UIColor.red
}

