//
//  TutorialViewController.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {
	@IBOutlet var hurryupLabel: UILabel!
	@IBOutlet var enemyImage: UIImageView!
	@IBOutlet var playerImage: UIImageView!
	@IBOutlet var goalImage: UIImageView!
	@IBOutlet var firstArrow: UIImageView!
	@IBOutlet var secondArrow: UIImageView!

	override open func viewDidLoad() {
		super.viewDidLoad()

		// enemyImage stuff
		enemyImage.animationImages = TileType.enemy.images
		enemyImage.animationDuration = 0.4
		enemyImage.animationRepeatCount = 0
		enemyImage.startAnimating()

		// playerImage stuff
		playerImage.animationImages = TileType.player.images
		playerImage.animationDuration = 0.4
		playerImage.animationRepeatCount = 0
		playerImage.startAnimating()

		// goalImage stuff
		goalImage.animationImages = [TileType.goal_close.image!, TileType.goal_open.image!]
		goalImage.animationDuration = 0.4
		goalImage.animationRepeatCount = 0
		goalImage.startAnimating()

		// arrows stuff
		firstArrow.image = firstArrow.image?.withRenderingMode(.alwaysTemplate)
		firstArrow.tintColor = .cyan
		firstArrow.flash()

		secondArrow.image = secondArrow.image?.withRenderingMode(.alwaysTemplate)
		secondArrow.tintColor = .cyan
		secondArrow.flash()
	}

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hurryupLabel.flash()
	}

	// MARK: - Actions

	@IBAction func newGame() {
		play(sound: .game)
		coordinator.show(screen: .game)
	}
}
