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
		case .bomb, .hearth:
			color = .red
		case .coin:
			color = .yellow
		case .key:
			color = .green
		case .time:
			color = .magenta
		default:
			color = .white
		}

		return UIImage(named: "\(rawValue)")?.withTintColor(color)
	}
}
