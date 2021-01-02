//
//  BestScoresViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class BestScoresViewController: UIViewController {
	@IBOutlet var tableView: UITableView!
	@IBOutlet var backButton: UIButton!

	//MARK: - Actions

	@IBAction func backTouched() {
		playSound(SoundType.selectItem)
		AppDelegate.sharedInstance.selectScreen(.STMenu)
	}
}

extension BestScoresViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = ScoreManager.highScores.count
		return count < 10 ? 10 : count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		cell.backgroundColor = UIColor.white
		cell.textLabel?.textColor = UIColor.black
		cell.textLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)
		cell.detailTextLabel?.textColor = UIColor.black
		cell.detailTextLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)

		let highScores = ScoreManager.highScores
		if indexPath.row <= highScores.count - 1 {
			let score = highScores[indexPath.row]
			cell.textLabel?.text = "mmmaze.game.score".localized
			cell.detailTextLabel?.text = "\(score)"
		}
		else {
			cell.textLabel?.text = "mmmaze.game.score".localized
			cell.detailTextLabel?.text = "xxx"
		}
		return cell
	}
}
