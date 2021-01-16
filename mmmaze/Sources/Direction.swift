//
//  Direction.swift
//  mmmaze
//
//  Created by mugx on 16/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

enum Direction: String {
	case up
	case down
	case left
	case right

	var isVertical: Bool { self == .up || self == .down }
	var isHorizontal: Bool { self == .left || self == .right }
	
	init?(_ direction: UISwipeGestureRecognizer.Direction) {
		switch direction {
		case .up: self = .up
		case .down: self = .down
		case .left: self = .left
		case .right: self = .right
		default: return nil
		}
	}
}
