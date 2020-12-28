//
//  SettingsViewController.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
	@IBOutlet var settingsTitleLabel: UILabel!
	@IBOutlet var soundEnabledView: UIView!
	@IBOutlet var soundEnabledTitleLabel: UILabel!
	@IBOutlet var soundEnabledValueLabel: UILabel!
	@IBOutlet var soundVolumeView: UIView!
	@IBOutlet var soundVolumeTitleLabel: UILabel!
	@IBOutlet var soundVolumeValueLabel: UILabel!
	@IBOutlet var backButton: UIButton!

	enum VolumeType: Int {
		case mute = 0
		case low = 1
		case mid = 5
		case high = 10
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		refresh()
	}

	//MARK: - Refresh

	func refresh() {
		soundEnabledTitleLabel.text = "mmmaze.settings.sound".localized
		soundEnabledValueLabel.text = AudioManager.shared.soundEnabled ? "mmmaze.settings.enabled".localized : "mmmaze.settings.disabled".localized
		soundVolumeTitleLabel.text = "mmmaze.settings.volume".localized
		backButton.setTitle("mmmaze.menu.back".localized, for: .normal)
		refreshSoundVolume()
	}

	func refreshSoundVolume() {
		switch VolumeType(rawValue: Int(AudioManager.shared.volume * 10))! {
		case .mute:
			soundVolumeValueLabel.text = "mmmaze.settings.volume_mute".localized
		case .low:
			soundVolumeValueLabel.text = "mmmaze.settings.volume_low".localized
		case .mid:
			soundVolumeValueLabel.text = "mmmaze.settings.volume_mid".localized
		case .high:
			soundVolumeValueLabel.text = "mmmaze.settings.volume_high".localized
		}
	}

	//MARK: - IBActions

	@IBAction func languageDecrTouched() {
		AudioManager.shared.play(SoundType.STSelectItem)

		//--- decr logic ---//
		let langs = MXLocalizationManager.sharedInstance()!.availableLanguages()!
		for i in 0...langs.count {
			let currentCode = langs[i] as! String
			if currentCode == MXLocalizationManager.sharedInstance()!.currentLanguageCode! {
				let newIndex = (i - 1 + langs.count) % langs.count
				let newLangCode = langs[newIndex] as! String
				MXLocalizationManager.sharedInstance()?.currentLanguageCode = newLangCode
				break
			}
		}
		refresh()
	}

	@IBAction func languageIncrTouched() {
		AudioManager.shared.play(SoundType.STSelectItem)

		//--- incr logic ---//
		let langs = MXLocalizationManager.sharedInstance()!.availableLanguages()!
		for i in 0...langs.count {
			let currentCode = langs[i] as! String
			if currentCode == MXLocalizationManager.sharedInstance()!.currentLanguageCode! {
				let newIndex = (i + 1) % langs.count
				let newLangCode = langs[newIndex] as! String
				MXLocalizationManager.sharedInstance()?.currentLanguageCode = newLangCode
				break
			}
		}
		refresh()
	}

	@IBAction func soundVolumeTouched() {
		switch VolumeType(rawValue: Int(AudioManager.shared.volume * 10))! {
		case .mute:
			AudioManager.shared.volume = Float(VolumeType.low.rawValue) / 10.0
		case .low:
			AudioManager.shared.volume = Float(VolumeType.mid.rawValue) / 10.0
		case .mid:
			AudioManager.shared.volume = Float(VolumeType.high.rawValue) / 10.0
		case .high:
			AudioManager.shared.volume = Float(VolumeType.mute.rawValue) / 10.0
		}
		AudioManager.shared.play(SoundType.STSelectItem)
		refresh()
	}

	@IBAction func soundEnabledTouched() {
		AudioManager.shared.soundEnabled = !AudioManager.shared.soundEnabled
		AudioManager.shared.play(SoundType.STSelectItem)
		refresh()
	}

	@IBAction func backTouched() {
		AudioManager.shared.play(SoundType.STSelectItem)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STMenu)
	}
}
