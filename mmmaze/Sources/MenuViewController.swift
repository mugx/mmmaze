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
	var hasGameInit: Bool = false

	init(coordinator: ScreenCoordinator, hasGameInit: Bool) {
		self.hasGameInit = hasGameInit
		super.init(coordinator: coordinator)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		versionLabel.text = APP_VERSION

		let title = (hasGameInit ? "menu.resume_game" : "menu.new_game").localized
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
