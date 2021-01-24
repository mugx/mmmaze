//
//  TimeInteractor.swift
//  mmmaze
//
//  Created by mugx on 24/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

protocol TimeInteractorDelegate: class {
	func didUpdate(time: TimeInterval)
	func didHurryUp()
	func didGameOver(from interactor: TimeInteractor)
}

class TimeInteractor {
	private let delegate: TimeInteractorDelegate
	private var currentTime: TimeInterval = 0
	private static let MAX_TIME: TimeInterval = 60

	init(delegate: TimeInteractorDelegate) {
		self.delegate = delegate
		self.currentTime = Self.MAX_TIME
	}

	// MARK: - Public
	
	func update(_ delta: TimeInterval) {
		currentTime -= delta

		switch currentTime {
		case 0:
			currentTime = 0
			delegate.didGameOver(from: self)
		case 1..<10:
			delegate.didHurryUp()
			fallthrough
		default:
			delegate.didUpdate(time: currentTime)
		}
	}
}
