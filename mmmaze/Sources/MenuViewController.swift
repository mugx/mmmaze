//
//  MenuViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
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
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
		if AppDelegate.sharedInstance.gameVc == nil {
			AppDelegate.sharedInstance.selectScreen(ScreenType.STTutorial)
		} else {
			AppDelegate.sharedInstance.selectScreen(ScreenType.STResumeGame)
		}
	}

	@IBAction func highScoresTouched() {
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STHighScores)
	}

	@IBAction func settingsTouched() {
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STSettings)
	}

	@IBAction func aboutTouched() {
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STCredits)
	}
}
