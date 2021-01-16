//
//  CreditsViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class CreditsViewController: BaseViewController {
	@IBOutlet var versionLabel: UILabel!

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		versionLabel.text = APP_VERSION
	}

	// MARK: - Actions

	@IBAction func backTouched() {
		play(sound: .selectItem)
		coordinator.show(screen: .menu)
	}
}
