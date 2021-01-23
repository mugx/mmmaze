//
//  GameViewController.swift
//  mmmaze
//
//  Created by mugx on 12/10/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController {
	@IBOutlet var headerView: HeaderView!
	@IBOutlet var gameOverView: GameOverView!
	@IBOutlet var currentLevelView: CurrentLevelView!
	@IBOutlet var currentLivesLabel: UILabel!
	@IBOutlet var hurryUpView: HurryUpView!
	@IBOutlet var gameView: UIView!
	private var gameInteractor: GameInteractor?
	private var gestureRecognizer: GestureRecognizer?
	private var displayLink: DisplayLink?

	override open func viewDidLoad() {
		super.viewDidLoad()

		gameInteractor = GameInteractor(gameView: gameView, delegate: self)
		gestureRecognizer = GestureRecognizer(view: gameView, delegate: gameInteractor!)
		displayLink = DisplayLink(delegate: gameInteractor)
	}

	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		displayLink?.start()
		headerView.show()
	}

	// MARK: - Actions

	@IBAction func pauseAction() {
		displayLink?.stop()
		coordinator.show(screen: .menu)
	}
}

// MARK: - GameOverViewDelegate

extension GameViewController: GameOverViewDelegate {
	func didTap() {
		displayLink?.start()
	}
}

// MARK: - GameInteractorDelegate

extension GameViewController: GameInteractorDelegate {
	public func didUpdate(score: UInt) {
		headerView.didUpdate(score: score)
	}

	public func didUpdate(time: TimeInterval) {
		headerView.didUpdate(time: time)
	}

	public func didUpdate(lives: UInt) {
		currentLivesLabel.text = String(describing: lives)
	}

	public func didUpdate(level: UInt) {
		hurryUpView.stop()
		currentLevelView.didUpdate(level)
	}

	public func didHurryUp() {
		hurryUpView.didHurryUp()
	}

	func didGameOver(with score: UInt) {
		displayLink?.stop()
		gameOverView.didGameOver(with: score)
	}
}
