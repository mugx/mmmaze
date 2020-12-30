//
//  Tile.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension Tile {
	func restoreAnimations() {
		animations.forEach({ (arg0) in
			layer.add(arg0.value as! CAAnimation, forKey: arg0.key as? String)
		})
	}
}
