//
//  GameOverView.swift
//  mmmaze
//
//  Created by mugx on 12/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

@objc protocol GameOverViewDelegate {
	func didTap()
}

class GameOverView: UIView {
	@IBOutlet var scoreValueLabel: UILabel!
	@IBOutlet var highScoreValueLabel: UILabel!
	@IBOutlet weak var delegate: GameOverViewDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		
		isHidden = true
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
	}

	// MARK: - Actions

	func didGameOver(with score: UInt) {
		isHidden = false
		alpha = 0

		scoreValueLabel.text = "\(score)"
		highScoreValueLabel.text = String(describing: ScoreManager.bestScore)

		UIView.animate(withDuration: 0.5) {
			self.alpha = 1.0
		}
	}
	
	@objc func didTap() {
		isHidden = true
		delegate?.didTap()
	}
}
