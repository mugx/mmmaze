//
//  TNHighScoresViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
//

import Foundation

class TNHighScoresViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    
    static func create() -> TNHighScoresViewController {
        let highScoresViewController = TNHighScoresViewController(nibName: nil, bundle: nil)
        return highScoresViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.borderColor = Constants.magentaColor.cgColor
        tableView.layer.borderWidth = 2.0
        backButton.layer.borderColor = Constants.magentaColor.cgColor
        backButton.layer.borderWidth = 2.0
    }
    
    @objc func getHighScores() -> [Any]? {
        UserDefaults.standard.array(forKey: SAVE_KEY_HIGH_SCORES)
    }
    
    //MARK: - Actions
    
    @IBAction func backTouched() {
        MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
        AppDelegate.sharedInstance.selectScreen(.STMenu)
    }
}

@objc extension TNHighScoresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = getHighScores()?.count ?? 0
        if count < 10 {
            count = 10
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = Constants.whiteColor
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)
        cell.detailTextLabel?.textColor = Constants.whiteColor;
        cell.detailTextLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: 16)
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
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
