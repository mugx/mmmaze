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

		enemyImage.set(images: TileType.enemy.images)
		playerImage.set(images: TileType.player.images)
		goalImage.set(images: [TileType.goal_close.image, TileType.goal_open.image])

		firstArrow.flash()
		secondArrow.flash()
		hurryupLabel.flash()
	}

	// MARK: - Actions

	@IBAction func newGame() {
		play(sound: .game)
		coordinator.show(screen: .game)
	}
}
