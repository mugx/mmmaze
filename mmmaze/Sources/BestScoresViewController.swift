//
//  BestScoresViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import Foundation

class BestScoresViewController: UIViewController {
	@IBOutlet var tableView: UITableView!
	@IBOutlet var backButton: UIButton!

	@objc func getHighScores() -> [Any]? {
		UserDefaults.standard.array(forKey: SAVE_KEY_HIGH_SCORES)
	}

	//MARK: - Actions

	@IBAction func backTouched() {
		AudioManager.shared.play(SoundType.STSelectItem)
		AppDelegate.sharedInstance.selectScreen(.STMenu)
	}
}

@objc extension BestScoresViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var count = getHighScores()?.count ?? 0
		if count < 10 {
			count = 10
		}
		return count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		cell.backgroundColor = UIColor.white
		cell.textLabel?.textColor = UIColor.black
		cell.textLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)
		cell.detailTextLabel?.textColor = UIColor.black;
		cell.detailTextLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)

		let highScores = getHighScores() ?? []
		if indexPath.row <= highScores.count - 1 {
			let score = highScores[indexPath.row]
			cell.textLabel?.text = "mmmaze.game.score".localized
			cell.detailTextLabel?.text = "\(score)"
		}
		else {
			cell.textLabel?.text = "mmmaze.game.score".localized
			cell.detailTextLabel?.text = "xxx"
		}
		return cell;
	}
}
