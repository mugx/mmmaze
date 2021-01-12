//
//  GameStats.swift
//  mmmaze
//
//  Created by mugx on 11/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class GameStats {
	static let MAX_TIME: TimeInterval = 60
	static let MAX_LIVES: UInt = 3
	var currentLives: UInt = 0
	var currentTime: TimeInterval = 0
	var isGameOver: Bool = false
	var isGameStarted: Bool = false
	var currentLevel: UInt = 0
	var currentScore: UInt = 0
	var mazeRotation: CGFloat = 0

	func startLevel(_ levelNumber: UInt) {
		currentLevel = levelNumber
		currentTime = Self.MAX_TIME
		isGameStarted = false
		isGameOver = false
		currentScore = levelNumber == 1 ? 0 : currentScore
		currentLives = levelNumber == 1 ? Self.MAX_LIVES : currentLives
	}
}
