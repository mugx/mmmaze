//
//  Sequennce+Utils.swift
//  mmmaze
//
//  Created by mugx on 03/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

extension Sequence where Iterator.Element == CGRect {
	func collides(target: CGRect) -> Bool {
		return contains { (element) -> Bool in
			element.intersects(target)
		}
	}
}
