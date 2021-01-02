//
//  TutorialViewController.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
	@IBOutlet var enemyImage: UIImageView!
	@IBOutlet var enemyImage2: UIImageView!
	@IBOutlet var playerImage: UIImageView!
	@IBOutlet var goalImage: UIImageView!
	@IBOutlet var firstArrow: UIImageView!
	@IBOutlet var secondArrow: UIImageView!
	@IBOutlet var hurryupLabel: UILabel!

	override open func viewDidLoad() {
		super.viewDidLoad()

		//--- enemyImage stuff ---//
		enemyImage.animationImages = UIImage(named: "enemy")?.sprites(with: TILE_SIZE)
		enemyImage.animationDuration = 0.4
		enemyImage.animationRepeatCount = 0
		enemyImage.startAnimating()

		//--- playerImage stuff ---//
		playerImage.animationImages = UIImage(named: "player")?.sprites(with: TILE_SIZE)
		playerImage.animationDuration = 0.4
		playerImage.animationRepeatCount = 0
		playerImage.startAnimating()

		//--- goalImage stuff ---//
		goalImage.animationImages = [UIImage(named: "gate_open")!, UIImage(named: "gate_close")!]
		goalImage.animationDuration = 0.4
		goalImage.animationRepeatCount = 0
		goalImage.startAnimating()

		//--- arrows stuff ---//
		firstArrow.image = firstArrow.image?.withRenderingMode(.alwaysTemplate)
		firstArrow.tintColor = .cyan
		UIView.animate(withDuration: 0.15, delay: 0, options: [.repeat, .autoreverse], animations: {
			self.firstArrow.alpha = 0.4
		}) { (finished) in
			self.firstArrow.alpha = 1.0
		}

		secondArrow.image = secondArrow.image?.withRenderingMode(.alwaysTemplate)
		secondArrow.tintColor = .cyan
		UIView.animate(withDuration: 0.15, delay: 0, options: [.repeat, .autoreverse], animations: {
			self.secondArrow.alpha = 0.4
		}) { (finished) in
			self.secondArrow.alpha = 1.0
		}
	}

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		UIView.animate(withDuration: 0.15, delay: 0, options: [.repeat, .autoreverse]) {
			self.hurryupLabel.alpha = 0.4
		}
	}

	//MARK: - IBAction

	@IBAction func newGame() {
		AppDelegate.sharedInstance.selectScreen(.STNewGame)
	}
}
