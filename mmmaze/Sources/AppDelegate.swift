//
//  AppDelegate.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
//

import Foundation

@objcMembers
@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
	static var sharedInstance: AppDelegate! { return (UIApplication.shared.delegate as! AppDelegate) }
	var window: UIWindow?
	var gameVc: GameViewController?

	func applicationDidFinishLaunching(_ application: UIApplication) {
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		window.rootViewController = MenuViewController()

		//-- prepare sounds ---//
		prepareSounds()

		//  //-- Show the splash screen ---//
		let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
		let launchScreenVC = storyboard.instantiateViewController(withIdentifier: "LaunchScreen")
		window.rootViewController?.present(launchScreenVC, animated: false, completion: {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				launchScreenVC.dismiss(animated: true, completion: nil)
			}
		})
		window.makeKeyAndVisible()
	}

	func prepareSounds() {
		MXAudioManager.sharedInstance()?.soundEnabled = Bool(truncating: Constants.SOUND_ENABLED as NSNumber)
		MXAudioManager.sharedInstance()?.volume = Constants.SOUND_DEFAULT_VOLUME
		let json = MXUtils.json(fromFile: "gameConfiguration.json") as?  [AnyHashable: Any]
		MXAudioManager.sharedInstance()?.load(json)
	}

	//MARK: - Select Screen

	func selectScreen(_ screenType:ScreenType ) {
		switch (screenType) {
		case .STMenu:
			transitionToViewController(MenuViewController())
		case .STTutorial:
			transitionToViewController(TutorialViewController())
		case .STNewGame:
			gameVc = GameViewController.create()
			transitionToViewController(gameVc!)
		case .STResumeGame:
			transitionToViewController(gameVc!)
		case .STHighScores:
			transitionToViewController(TNHighScoresViewController.create())
		case .STSettings:
			transitionToViewController(TNSettingsViewController.create())
		case .STCredits:
			transitionToViewController(TNCreditsViewController.create())
		default:
			break
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
