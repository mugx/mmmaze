//
//  SettingsViewController.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
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

	// MARK: - Refresh

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

	// MARK: - Actions

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
		playSound(SoundType.selectItem)
		refresh()
	}

	@IBAction func soundEnabledTouched() {
		AudioManager.shared.soundEnabled = !AudioManager.shared.soundEnabled
		playSound(SoundType.selectItem)
		refresh()
	}

	@IBAction func backTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.shared.selectScreen(ScreenType.STMenu)
	}
}
