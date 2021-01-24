//
//  ScreenCoordinator.swift
//  mmmaze
//
//  Created by mugx on 16/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class ScreenCoordinator {
	enum ScreenType {
		case menu
		case tutorial
		case game
		case settings
		case highScores
		case credits
	}

	private let window: UIWindow
	private var gameVc: GameViewController?

	init() {
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		window.makeKeyAndVisible()
	}

	// MARK: - Public

	func start() {
		window.rootViewController = UIViewController()
		show(screen: .menu)
	}

	func show(screen type: ScreenType) {
		switch type {
		case .menu:
			show(MenuViewController(coordinator: self, hasGame: gameVc != nil))
		case .tutorial:
			show(TutorialViewController(coordinator: self))
		case .game:
			showGame()
		case .highScores:
			show(BestScoresViewController(coordinator: self))
		case .settings:
			show(SettingsViewController(coordinator: self))
		case .credits:
			show(CreditsViewController(coordinator: self))
		}
	}

	// MARK: - Private

	func showGame() {
		if gameVc == nil {
			show(screen: .tutorial)
			gameVc = GameViewController(coordinator: self)
		} else {
			show(gameVc!)
		}
	}

	private func show(_ viewController: UIViewController) {
		UIView.animate(withDuration: 0.5, animations: {
			self.window.rootViewController?.view.alpha = 0
		}) { (success) in
			self.window.rootViewController = viewController
			UIView.animate(withDuration: 1) {
				self.window.rootViewController?.view.alpha = 1
			}
		}
	}
}
