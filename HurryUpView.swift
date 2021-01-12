//
//  HurryUpView.swift
//  mmmaze
//
//  Created by mugx on 12/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class HurryUpView: UILabel {

	func didHurryUp() {
		guard isHidden else { return }

		isHidden = false
		alpha = 0

		UIView.animate(withDuration: 0.1, animations: {
			self.alpha = 1
		}) { (success) in
			play(sound: .timeOver)

			// Add the animation
			let animation = CABasicAnimation(keyPath: "opacity")
			animation.fromValue = 1.0
			animation.toValue = 0.5
			animation.autoreverses = true
			animation.repeatCount = HUGE
			animation.duration = 0.15
			self.layer.add(animation, forKey: "opacity")
		}
	}

	func stop() {
		isHidden = true
	}
}

