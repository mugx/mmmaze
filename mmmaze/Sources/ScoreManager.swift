//
//  GameCenter.swift
//  mmmaze
//
//  Created by mugx on 28/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

class ScoreManager {
	private static let SAVE_KEY_HIGH_SCORES = "highScores"
	private static let MAX_HIGH_SCORES_COUNT = 10

	static var highScore: UInt {
		highScores.first ?? 0
	}
	
	static var highScores: [UInt] {
		UserDefaults.standard.object(forKey: SAVE_KEY_HIGH_SCORES) as? [UInt] ?? []
	}

	static func save(score: UInt) {
		var highScores = Self.highScores
		highScores.append(score)
		highScores.sort(by: { (a, b) -> Bool in
			a > b
		})
		if highScores.count > Self.MAX_HIGH_SCORES_COUNT {
			highScores.removeLast()
		}
		UserDefaults.standard.setValue(highScores, forKey: Self.SAVE_KEY_HIGH_SCORES)
	}

	// MARK: - Private
}
