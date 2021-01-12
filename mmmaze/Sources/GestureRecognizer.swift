//
//  GestureRecognizer.swift
//  mmmaze
//
//  Created by mugx on 12/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

protocol GestureRecognizerDelegate {
	func didSwipe(_ direction: UISwipeGestureRecognizer.Direction)
}

class GestureRecognizer: NSObject {
	var delegate: GestureRecognizerDelegate?

	func attach(to view: UIView, with delegate: GestureRecognizerDelegate?) {
		self.delegate = delegate

		let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
		swipeRight.direction = UISwipeGestureRecognizer.Direction.right
		view.addGestureRecognizer(swipeRight)

		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
		swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
		view.addGestureRecognizer(swipeLeft)

		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
		swipeUp.direction = UISwipeGestureRecognizer.Direction.up
		view.addGestureRecognizer(swipeUp)

		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
		swipeDown.direction = UISwipeGestureRecognizer.Direction.down
		view.addGestureRecognizer(swipeDown)
	}

	@objc func didSwipe(sender: UISwipeGestureRecognizer) {
		delegate?.didSwipe(sender.direction)
	}
}
