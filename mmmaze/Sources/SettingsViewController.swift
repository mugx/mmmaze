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
		soundEnabledValueLabel.text = MXAudioManager.sharedInstance()!.soundEnabled ? "mmmaze.settings.enabled".localized : "mmmaze.settings.disabled".localized
		soundVolumeTitleLabel.text = "mmmaze.settings.volume".localized
		backButton.setTitle("mmmaze.menu.back".localized, for: .normal)
		refreshSoundVolume()
	}

	func refreshSoundVolume() {
		switch VolumeType(rawValue: Int(MXAudioManager.sharedInstance()!.volume * 10))! {
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
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)

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
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)

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
		switch VolumeType(rawValue: Int(MXAudioManager.sharedInstance()!.volume * 10))! {
		case .mute:
			MXAudioManager.sharedInstance()!.volume = Float(VolumeType.low.rawValue) / 10.0
		case .low:
			MXAudioManager.sharedInstance()!.volume = Float(VolumeType.mid.rawValue) / 10.0
		case .mid:
			MXAudioManager.sharedInstance()!.volume = Float(VolumeType.high.rawValue) / 10.0
		case .high:
			MXAudioManager.sharedInstance()!.volume = Float(VolumeType.mute.rawValue) / 10.0
		}
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
		refresh()
	}

	@IBAction func soundEnabledTouched() {
		MXAudioManager.sharedInstance()?.soundEnabled = !MXAudioManager.sharedInstance()!.soundEnabled
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
		refresh()
	}

	@IBAction func backTouched() {
		MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
		AppDelegate.sharedInstance.selectScreen(ScreenType.STMenu)
	}
}
