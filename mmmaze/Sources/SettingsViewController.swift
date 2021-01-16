//
//  SettingsViewController.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
	@IBOutlet var soundEnabledLabel: UILabel!
	@IBOutlet var soundVolumeLabel: UILabel!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		refresh()
	}

	// MARK: - Refresh

	func refresh() {
		soundEnabledLabel.text = "settings.\(AudioManager.shared.soundEnabled ? "enabled" : "disabled")".localized
		soundVolumeLabel.text = "settings.volume_\(String(describing: AudioManager.shared.volume))".localized
	}

	// MARK: - Actions

	@IBAction func soundVolumeTouched() {
		AudioManager.shared.volume.next()
		play(sound: .selectItem)
		refresh()
	}

	@IBAction func soundEnabledTouched() {
		AudioManager.shared.soundEnabled.toggle()
		play(sound: .selectItem)
		refresh()
	}

	@IBAction func backTouched() {
		play(sound: .selectItem)
		coordinator.show(screen: .menu)
	}
}
