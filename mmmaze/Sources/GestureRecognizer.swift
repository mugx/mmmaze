//
//  GestureRecognizer.swift
//  mmmaze
//
//  Created by mugx on 12/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

protocol GestureRecognizerDelegate: class {
	func didSwipe(_ direction: Direction)
}

class GestureRecognizer {
	private weak var delegate: GestureRecognizerDelegate?

	init(view: UIView, delegate: GestureRecognizerDelegate) {
		self.delegate = delegate

		defer {
			let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeRight.direction = .right
			view.addGestureRecognizer(swipeRight)

			let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeLeft.direction = .left
			view.addGestureRecognizer(swipeLeft)

			let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeUp.direction = .up
			view.addGestureRecognizer(swipeUp)

			let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeDown.direction = .down
			view.addGestureRecognizer(swipeDown)
		}
	}

	@objc func didSwipe(sender: UISwipeGestureRecognizer) {
		guard let direction = Direction(sender.direction) else {
			return
		}

		delegate?.didSwipe(direction)
	}
}
