//
//  HeaderView.swift
//  mmmaze
//
//  Created by mugx on 12/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class HeaderView: UIView {
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		isHidden = true
	}

	func show() {
		isHidden = false
	}

	func didUpdate(score: UInt) {
		scoreLabel.text = "\("game.score".localized)\n\(score)"
	}

	func didUpdate(time: TimeInterval) {
		timeLabel.text = "\("game.time".localized)\n\(Int(time))"
	}
}
