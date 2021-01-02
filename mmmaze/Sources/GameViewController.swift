//
//  GameViewController.swift
//  mmmaze
//
//  Created by mugx on 12/10/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
	var gameSession: GameSession!
	var displayLink: CADisplayLink!
	var previousTimestamp: CFTimeInterval = 0.0
	var swipeRight: UISwipeGestureRecognizer!
	var swipeLeft: UISwipeGestureRecognizer!
	var swipeUp: UISwipeGestureRecognizer!
	var swipeDown: UISwipeGestureRecognizer!
	@IBOutlet var gameView: UIView!
	@IBOutlet var headerView: UIView!
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	@IBOutlet var currentLivesLabel: UILabel!
	@IBOutlet var gameOverView: UIView!
	@IBOutlet var gameOverPanel: UIView!
	@IBOutlet var scoreValueLabel_inGameOver: UILabel!
	@IBOutlet var highScoreValueLabel_inGameOver: UILabel!
	@IBOutlet var currentLevelPanel: UIView!
	@IBOutlet var currentLevelLabel: UILabel!
	@IBOutlet var hurryUpLabel: UILabel!

	override open func viewDidLoad() {
		super.viewDidLoad()
		gameOverView.isHidden = true
		headerView.isHidden = true
	}

	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		headerView.isHidden = false

		if gameSession == nil {
			// setup current level stuff
			currentLevelPanel.isHidden = true

			// setup swipes
			swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeRight.direction = UISwipeGestureRecognizer.Direction.right
			swipeRight.delegate = self
			gameView.addGestureRecognizer(swipeRight)

			swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
			swipeLeft.delegate = self
			gameView.addGestureRecognizer(swipeLeft)

			swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeUp.direction = UISwipeGestureRecognizer.Direction.up
			swipeUp.delegate = self
			gameView.addGestureRecognizer(swipeUp)

			swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
			swipeDown.direction = UISwipeGestureRecognizer.Direction.down
			swipeDown.delegate = self
			gameView.addGestureRecognizer(swipeDown)

			// game over view
			gameOverView.isHidden = true

			// setup game session
			gameSession = GameSession(view: gameView)
			gameSession.delegate = self
			gameSession.startLevel(1)
		}

		// setup timer
		displayLink = CADisplayLink(target: self, selector: #selector(update))
		displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
		gameSession.items.forEach { $0.restoreAnimations() }
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return true
	}

	// MARK: - Actions

	@IBAction func pauseAction() {
		displayLink.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
		AppDelegate.shared.selectScreen(ScreenType.STMenu)
	}

	@IBAction func gameOverTouched() {
		gameOverView.isHidden = true
		view.sendSubviewToBack(gameOverView)
		hurryUpLabel.isHidden = true
		gameSession.startLevel(1)

		// setup timer
		displayLink = CADisplayLink(target: self, selector: #selector(update))
		displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
	}

	// MARK: - Gesture Recognizer Stuff

	@objc func didSwipe(sender: UISwipeGestureRecognizer) {
		gameSession.didSwipe(sender.direction)
	}

	// MARK: - Update Stuff

	@objc func update() {
		let currentTime = displayLink.timestamp
		var deltaTime = currentTime - previousTimestamp
		previousTimestamp = currentTime
		deltaTime = deltaTime < 0.1 ? deltaTime : 0.015
		gameSession.update(deltaTime)
	}
}

// MARK: - GameSessionDelegate

extension GameViewController: GameSessionDelegate {
	public func didUpdateScore(_ score: UInt) {
		scoreLabel.text = "\("mmmaze.game.score".localized)\n\(score)"
		scoreValueLabel_inGameOver.text = "\(score)"
	}

	public func didUpdateTime(_ time: TimeInterval) {
		timeLabel.text = "\("mmmaze.game.time".localized)\n\(Int(time))"
	}

	public func didUpdateLives(_ livesCount: UInt) {
		currentLivesLabel.text = "\(livesCount)"
	}

	public func didUpdateLevel(_ levelCount: UInt) {
		hurryUpLabel.isHidden = true
		currentLevelPanel.isHidden = false
		currentLevelPanel.alpha = 0
		currentLevelLabel.text = "\("mmmaze.game.level".localized) \(levelCount)"

		UIView.animate(withDuration: 0.2, animations: {
			self.currentLevelPanel.alpha = 1
		}) { (success) in
			UIView.animate(withDuration: 0.2, delay: 1.5, options: [], animations: {
				self.currentLevelPanel.alpha = 0
			}) { (success) in
				self.currentLevelPanel.isHidden = true
			}
		}
	}

	public func didHurryUp() {
		if hurryUpLabel.isHidden {
			hurryUpLabel.isHidden = false
			hurryUpLabel.alpha = 0

			UIView.animate(withDuration: 0.1, animations: {
				self.hurryUpLabel.alpha = 1
			}) { (success) in
				playSound(SoundType.timeOver)

				// Add the animation
				let animation = CABasicAnimation(keyPath: "opacity")
				animation.fromValue = 1.0
				animation.toValue = 0.5
				animation.autoreverses = true
				animation.repeatCount = HUGE
				animation.duration = 0.15
				self.hurryUpLabel.layer.add(animation, forKey: "opacity")
			}
		}
	}

	func didGameOver(_ gameSession: GameSession) {
		displayLink.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
		gameOverView.isHidden = false
		view.bringSubviewToFront(gameOverView)
		gameOverView.alpha = 0
		gameOverPanel.isHidden = false
		highScoreValueLabel_inGameOver.text = String(describing: ScoreManager.highScore)

		UIView.animate(withDuration: 0.5, animations: {
			self.gameOverView.alpha = 1.0
		}) { (success) in
			ScoreManager.save(score: self.gameSession.currentScore)
		}
	}
}
