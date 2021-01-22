//
//  MenuViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
	@IBOutlet var versionLabel: UILabel!
	@IBOutlet var gameButton: UIButton!

	init(coordinator: ScreenCoordinator, hasGame: Bool) {
		super.init(coordinator: coordinator)
		title = (hasGame ? "menu.resume_game" : "menu.new_game").localized
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		versionLabel.text = Constants.APP_VERSION
		gameButton.titleLabel?.text = title
		gameButton.setTitle(title, for: .normal)
	}

	// MARK: - Actions

	@IBAction func newGameTouched() {
		play(sound: .selectItem)
		coordinator.show(screen: .game)
	}

	@IBAction func highScoresTouched() {
		play(sound: .selectItem)
		coordinator.show(screen: .highScores)
	}

	@IBAction func settingsTouched() {
		play(sound: .selectItem)
		coordinator.show(screen: .settings)
	}

	@IBAction func aboutTouched() {
		play(sound: .selectItem)
		coordinator.show(screen: .credits)
	}
}
