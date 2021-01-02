//
//  UISwipeGestureRecognizer+Utils.swift
//  mmmaze
//
//  Created by mugx on 02/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

extension UISwipeGestureRecognizer.Direction {
	var isVertical: Bool { self == UISwipeGestureRecognizer.Direction.up || self == UISwipeGestureRecognizer.Direction.down }
	var isHorizontal: Bool { self == UISwipeGestureRecognizer.Direction.left || self == UISwipeGestureRecognizer.Direction.right }
}
