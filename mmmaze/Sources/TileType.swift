//
//  TileType.swift
//  mmmaze
//
//  Created by mugx on 02/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

enum TileType: String {
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
	case player

	static func rand() -> TileType? {
		switch Float.random(in: 0 ..< 1) {
		case 0.99 ... 1: return .hearth
		case 0.98 ... 1: return .time
		case 0.9 ... 1: return .whirlwind
		case 0.85 ... 1: return .bomb
		case 0.5 ... 1: return .coin
		default: return nil
		}
	}

	var image: UIImage {
		UIImage(named: rawValue)!.withTintColor(color)
	}

	var images: [UIImage] {
		image.sprites(color: color) ?? []
	}

	// MARK: - Private

	private var color: UIColor {
		switch self {
		case .bomb, .hearth: return .red
		case .coin: return .yellow
		case .key: return .green
		case .time: return .magenta
		default: return .white
		}
	}
}
