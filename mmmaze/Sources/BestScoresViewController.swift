//
//  BestScoresViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class BestScoresViewController: BaseViewController {
	private var maxResults = 10

	// MARK: - Actions

	@IBAction func backTouched() {
		play(sound: .selectItem)
		coordinator.show(screen: .menu)
	}
}

// MARK: - UITableViewDataSource

extension BestScoresViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return maxResults
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		cell.backgroundColor = UIColor.white
		cell.textLabel?.textColor = UIColor.black
		cell.textLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)
		cell.detailTextLabel?.textColor = UIColor.black
		cell.detailTextLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)
		cell.textLabel?.text = "game.score".localized
		cell.detailTextLabel?.text = "xxx"

		let bestScores = ScoreManager.bestScores
		if indexPath.item <= bestScores.count - 1 {
			cell.detailTextLabel?.text = "\(bestScores[indexPath.item])"
		}

		return cell
	}
}
