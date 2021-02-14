//
//  BaseEntityType.swift
//  mmmaze
//
//  Created by mugx on 02/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

enum BaseEntityType: String {
	case wall
	case coin
	case rotator
	case bomb
	case time
	case hearth
	case key
	case enemy
	case goal_close
	case goal_open
	case minion
	case player

	var image: UIImage { UIImage(named: rawValue)! }

	var color: UIColor {
		switch self {
		case .bomb, .hearth: return .red
		case .coin: return .yellow
		case .key: return .green
		case .time: return .magenta
		default: return .white
		}
	}
}
