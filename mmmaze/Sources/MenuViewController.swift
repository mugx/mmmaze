//
//  MenuViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
	@IBOutlet var versionLabel: UILabel!
	@IBOutlet var gameButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		versionLabel.text = APP_VERSION

		let title = AppDelegate.shared.gameVc == nil ? "mmmaze.menu.new_game".localized : "mmmaze.menu.resume_game".localized
		gameButton.titleLabel?.text = title
		gameButton.setTitle(title, for: .normal)
	}

	// MARK: - Actions

	@IBAction func newGameTouched() {
		playSound(SoundType.selectItem)
		if AppDelegate.shared.gameVc == nil {
			AppDelegate.shared.selectScreen(ScreenType.STTutorial)
		} else {
			AppDelegate.shared.selectScreen(ScreenType.STResumeGame)
		}
	}

	@IBAction func highScoresTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.shared.selectScreen(ScreenType.STHighScores)
	}

	@IBAction func settingsTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.shared.selectScreen(ScreenType.STSettings)
	}

	@IBAction func aboutTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.shared.selectScreen(ScreenType.STCredits)
	}
}
