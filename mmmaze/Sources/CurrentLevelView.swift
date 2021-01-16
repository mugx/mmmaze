//
//  CurrentLevelView.swift
//  mmmaze
//
//  Created by mugx on 12/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class CurrentLevelView: UIView {
	@IBOutlet var levelLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		isHidden = true
	}
	
	public func didUpdate(_ level: UInt) {
		isHidden = false
		alpha = 0
		levelLabel.text = "\("game.level".localized) \(level)"

		UIView.animate(withDuration: 0.2, animations: {
			self.alpha = 1
		}) { (success) in
			UIView.animate(withDuration: 0.2, delay: 1.5, options: [], animations: {
				self.alpha = 0
			}) { (success) in
				self.isHidden = true
			}
		}
	}
}
