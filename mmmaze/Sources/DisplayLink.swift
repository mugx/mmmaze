//
//  DisplayLink.swift
//  mmmaze
//
//  Created by mugx on 12/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

protocol DisplayLinkDelegate: class {
	func start()
	func update(delta: TimeInterval)
}

class DisplayLink {
	private weak var delegate: DisplayLinkDelegate?
	private var displayLink: CADisplayLink?
	private var previousTimestamp: CFTimeInterval = 0.0

	init(delegate: DisplayLinkDelegate?) {
		self.delegate = delegate
	}

	// MARK: - Actions

	func start() {
		displayLink = CADisplayLink(target: self, selector: #selector(update))
		displayLink?.add(to: .main, forMode: .common)
		delegate?.start()
	}

	func stop() {
		displayLink?.remove(from: .main, forMode: .common)
	}
	
	@objc func update() {
		guard let displayLink = displayLink else { return }

		let currentTime = displayLink.timestamp
		var deltaTime = currentTime - previousTimestamp
		previousTimestamp = currentTime
		deltaTime = deltaTime < 0.1 ? deltaTime : 0.015
		delegate?.update(delta: deltaTime)
	}
}
