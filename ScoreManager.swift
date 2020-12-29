//
//  GameCenter.swift
//  mmmaze
//
//  Created by mugx on 28/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

class ScoreManager {
	static func highScore() -> Int64 {
		return (UserDefaults.standard.object(forKey: SAVE_KEY_HIGH_SCORES) as? Array<Int64>)?.first ?? 0
	}
}
