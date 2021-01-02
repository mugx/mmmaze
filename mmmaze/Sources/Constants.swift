//
//  Macros.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

enum ScreenType {
	case STMenu
	case STTutorial
	case STNewGame
	case STResumeGame
	case STSettings
	case STHighScores
	case STCredits
}

var TILE_SIZE = 32.0

class Constants {
//	static let TILE_SIDE = 32.0
//	static let TILE_SIZE = CGSize(width: Constants.TILE_SIDE, height: Constants.TILE_SIDE)
	static let STARTING_CELL = CGPoint(x: 1, y: 1)
	static let FONT_FAMILY = "Joystix"
}
