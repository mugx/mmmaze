//
//  AppDelegate.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

@main class AppDelegate: UIResponder, UIApplicationDelegate {
	private var screenCoordinator: ScreenCoordinator?

	func applicationDidFinishLaunching(_ application: UIApplication) {
		screenCoordinator = ScreenCoordinator()
		screenCoordinator?.start()
	}
}
