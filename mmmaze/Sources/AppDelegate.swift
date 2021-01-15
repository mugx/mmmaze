//
//  AppDelegate.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

enum ScreenType {
	case menu
	case tutorial
	case newGame
	case resumeGame
	case settings
	case highScores
	case credits
}

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
	static var shared: AppDelegate! { return (UIApplication.shared.delegate as! AppDelegate) }
	var window: UIWindow?
	var gameVc: GameViewController?

	func applicationDidFinishLaunching(_ application: UIApplication) {
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		window.makeKeyAndVisible()
		window.rootViewController = MenuViewController()
	}

	// MARK: - Select Screen

	func selectScreen(_ screenType:ScreenType ) {
		switch screenType {
		case .menu:
			transitionTo(viewController: MenuViewController())
		case .tutorial:
			transitionTo(viewController: TutorialViewController())
		case .newGame:
			gameVc = GameViewController()
			transitionTo(viewController: gameVc!)
		case .resumeGame:
			transitionTo(viewController: gameVc!)
		case .highScores:
			transitionTo(viewController: BestScoresViewController())
		case .settings:
			transitionTo(viewController: SettingsViewController())
		case .credits:
			transitionTo(viewController: CreditsViewController())
		}
	}

	func transitionTo(viewController: UIViewController) {
		guard let window = UIApplication.shared.windows.first else { return }

		UIView.animate(withDuration: 0.5, animations: {
			window.rootViewController?.view.alpha = 0
		}) { (success) in
			window.rootViewController = viewController
			UIView.animate(withDuration: 1) {
				window.rootViewController?.view.alpha = 1
			}
		}
	}
}
