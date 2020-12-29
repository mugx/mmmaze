//
//  Tile+AI.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

@objc extension Tile {
	@objc func collides(target: CGRect, path: Array<NSValue>) -> Bool {
		for p in path {
			if target.intersects(p.cgRectValue) {
				return true
			}
		}
		return false
	}
}
