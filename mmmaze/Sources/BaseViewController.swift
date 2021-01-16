//
//  BaseViewController.swift
//  mmmaze
//
//  Created by mugx on 16/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	let coordinator: ScreenCoordinator

	init(coordinator: ScreenCoordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
