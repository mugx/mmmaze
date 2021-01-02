//
//  AppDelegate.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
	static var sharedInstance: AppDelegate! { return (UIApplication.shared.delegate as! AppDelegate) }
	var window: UIWindow?
	var gameVc: GameViewController?

	func applicationDidFinishLaunching(_ application: UIApplication) {
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		window.makeKeyAndVisible()
		window.rootViewController = MenuViewController()
	}

	//MARK: - Select Screen

	func selectScreen(_ screenType:ScreenType ) {
		switch (screenType) {
		case .STMenu:
			transitionToViewController(MenuViewController())
		case .STTutorial:
			transitionToViewController(TutorialViewController())
		case .STNewGame:
			gameVc = GameViewController()
			transitionToViewController(gameVc!)
		case .STResumeGame:
			transitionToViewController(gameVc!)
		case .STHighScores:
			transitionToViewController(BestScoresViewController())
		case .STSettings:
			transitionToViewController(SettingsViewController())
		case .STCredits:
			transitionToViewController(CreditsViewController())
		}
	}

	func transitionToViewController(_ viewController: UIViewController) {
		UIView.animate(withDuration: 0.5, animations: {
			self.window?.rootViewController?.view.alpha = 0
		}) { (success) in
			//viewController.view.alpha = 0
			self.window?.rootViewController = viewController
			UIView.animate(withDuration: 1) {
				self.window?.rootViewController?.view.alpha = 1
			}
		}
	}
}
