//
//  TyleType.swift
//  mmmaze
//
//  Created by mugx on 02/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

enum TyleType: String {
	case none
	case start
	case wall
	case explodedWall
	case coin
	case whirlwind
	case bomb
	case time
	case hearth
	case key
	case enemy
	case goal_close
	case goal_open
	case minion
	case player_angry
	case player

	var image: UIImage? {
		var color: UIColor!

		switch self {
		case .bomb:
			color = .red
		case .coin:
			color = .yellow
		case .enemy:
			color = .white
		case .goal_close:
			color = .white
		case .goal_open:
			color = .white
		case .hearth:
			color = .red
		case .key:
			color = .green
		case .minion:
			color = .white
		case .player_angry:
			color = .white
		case .player:
			color = .white
		case .time:
			color = .magenta
		case .wall:
			color = .white
		case .whirlwind:
			color = .white
		case .none, .start, .explodedWall:
			break
		}

		return UIImage(named: "\(rawValue)")?.withTintColor(color)
	}
}
