//
//  CreditsViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import Foundation
import MessageUI

@objcMembers
class CreditsViewController: UIViewController {
	@IBOutlet var versionLabel: UILabel!
	@IBOutlet var logoIconImage: UIImageView!
	@IBOutlet var backButton: UIButton!

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		versionLabel.text = "v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!)"
	}

	//MARK: - Actions

	@IBAction func backTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.sharedInstance.selectScreen(.STMenu)
	}
}
