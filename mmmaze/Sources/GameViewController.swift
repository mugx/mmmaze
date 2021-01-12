//
//  GameViewController.swift
//  mmmaze
//
//  Created by mugx on 12/10/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
	@IBOutlet var gameOverView: GameOverView!
	@IBOutlet var currentLevelView: CurrentLevelView!
	@IBOutlet var hurryUpView: HurryUpView!
	@IBOutlet var headerView: HeaderView!
	@IBOutlet var gameView: UIView!
	@IBOutlet var currentLivesLabel: UILabel!
	private let displayLink = DisplayLink()
	private let gestureRecognizer = GestureRecognizer()
	private let gameSession = GameSession()

	override open func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		displayLink.start()
	}

	// MARK: - Actions

	@IBAction func pauseAction() {
		displayLink.stop()
		AppDelegate.shared.selectScreen(ScreenType.STMenu)
	}

	// MARK: - Private

	func setup() {
		gameOverView.delegate = self
		displayLink.delegate = gameSession
		gestureRecognizer.attach(to: gameView, with: gameSession)
		gameSession.attach(to: gameView, with: self)
		headerView.show()
	}
}

// MARK: - GameOverViewDelegate

extension GameViewController: GameOverViewDelegate {
	func didTap() {
		gameSession.startLevel()
		displayLink.start()
	}
}

// MARK: - GameSessionDelegate

extension GameViewController: GameSessionDelegate {
	public func didUpdate(score: UInt) {
		headerView.didUpdate(score: score)
	}

	public func didUpdate(time: TimeInterval) {
		headerView.didUpdate(time: time)
	}

	public func didUpdate(lives: UInt) {
		currentLivesLabel.text = "\(lives)"
	}

	public func didUpdate(level: UInt) {
		hurryUpView.stop()
		currentLevelView.didUpdate(level)
	}

	public func didHurryUp() {
		hurryUpView.didHurryUp()
	}

	func didGameOver(_ gameSession: GameSession, with score: UInt) {
		displayLink.stop()
		ScoreManager.save(score)
		gameOverView.didGameOver(with: score)
	}
}
