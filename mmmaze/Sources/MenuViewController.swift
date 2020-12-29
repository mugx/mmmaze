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
	@IBOutlet var highScoresButton: UIButton!
	@IBOutlet var settingsButton: UIButton!
	@IBOutlet var aboutButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		versionLabel.text = "v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!)"

		//--- setting buttons ---//
		let title = AppDelegate.sharedInstance.gameVc == nil ? "mmmaze.menu.new_game".localized : "mmmaze.menu.resume_game".localized
		gameButton.setTitle(title, for: .normal)
	}

	//MARK: - Actions

	@IBAction func newGameTouched() {
		playSound(SoundType.selectItem)
		if AppDelegate.sharedInstance.gameVc == nil {
			AppDelegate.sharedInstance.selectScreen(ScreenType.STTutorial)
		} else {
			AppDelegate.sharedInstance.selectScreen(ScreenType.STResumeGame)
		}
	}

	@IBAction func highScoresTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STHighScores)
	}

	@IBAction func settingsTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STSettings)
	}

	@IBAction func aboutTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STCredits)
	}
}
