//
//  Frame.swift
//  mmmaze
//
//  Created by mugx on 10/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation
import UIKit

typealias Rect = CGRect

class Frame: Equatable {
	var row: Int {
		let y = Float(rect.origin.y)
		let height = Float(rect.size.height)
		return height > 0 ? Int(floor(y / height)) : 0
	}

	var col: Int {
		let x = Float(rect.origin.x)
		let width = Float(rect.size.width)
		return width > 0 ? Int(floor(x / width)) : 0
	}

	static var zero: Frame { Frame(rect: .zero) }
	private(set) var rect: Rect = .zero
	static let SIZE: Int = 32

	static func == (lhs: Frame, rhs: Frame) -> Bool {
		lhs.rect == rhs.rect
	}

	convenience init(row: Int, col: Int) {
		self.init(rect: Rect(x: col * Self.SIZE, y: row * Self.SIZE, width: Self.SIZE, height: Self.SIZE))
	}

	init(rect: Rect) {
		self.rect = rect
	}

	func resize(with size: Float) -> Frame {
		let frame = Frame(rect: rect)
		frame.rect.size = CGSize(width: CGFloat(size), height: CGFloat(size))
		return frame
	}

	func centered() -> Frame {
		let speed_x = (CGFloat(Self.SIZE) - CGFloat(rect.size.width)) / 2.0
		let speed_y = (CGFloat(Self.SIZE) - CGFloat(rect.size.height)) / 2.0
		let x = rect.origin.x + speed_x
		let y = rect.origin.y + speed_y
		return Frame(rect: Rect(origin: CGPoint(x: x, y: y), size: rect.size))
	}
	
	func boundingTile() -> Frame {
		let size = CGFloat(Self.SIZE)
		let x = Int(round(rect.origin.x / size) * size)
		let y = Int(round(rect.origin.y / size) * size)
		return Frame(rect: Rect(x: x, y: y, width: Int(size), height: Int(size)))
	}

	func translate(x: CGFloat = 0, y: CGFloat = 0) -> Frame {
		let new_x = rect.origin.x + CGFloat(x)
		let new_y = rect.origin.y + CGFloat(y)
		return Frame(rect: Rect(x: new_x, y: new_y, width: rect.width, height: rect.height))
	}

	func translate(x: Float = 0, y: Float = 0) -> Frame {
		let new_x = rect.origin.x + CGFloat(x)
		let new_y = rect.origin.y + CGFloat(y)
		return Frame(rect: Rect(x: new_x, y: new_y, width: rect.width, height: rect.height))
	}

	func translate(x: Int = 0, y: Int = 0) -> Frame {
		let new_x = rect.origin.x + CGFloat(x)
		let new_y = rect.origin.y + CGFloat(y)
		return Frame(rect: Rect(x: new_x, y: new_y, width: rect.width, height: rect.height))
	}

	func follow(_ other: UIView) {
		rect = Rect(
			x: rect.size.width / 2.0 - other.frame.origin.x,
			y: rect.size.height / 2.0 - other.frame.origin.y,
			width: rect.size.width,
			height: rect.size.height
		)
	}

	func distance(to other: Frame) -> CGFloat {
		let center1 = CGPoint(x: rect.midX, y: rect.midY)
		let center2 = CGPoint(x: other.rect.midX, y: other.rect.midY)
		let horizontalDistance = center2.x - center1.x
		let verticalDistance = center2.y - center1.y
		let distance = sqrt(pow(horizontalDistance, 2) + pow(verticalDistance, 2))
		return distance
	}

	func manhattan(to other: Frame) -> CGFloat {
		return abs(rect.origin.x - other.rect.origin.x) + abs(rect.origin.y - other.rect.origin.y)
	}

	func collides(_ other: Frame) -> Bool {
		rect.intersects(other.rect)
	}

	func isNeighbour(of other: Frame) -> Bool {
		return
			translate(x: CGFloat(Self.SIZE)).collides(other) ||
			translate(x: CGFloat(-Self.SIZE)).collides(other) ||
			translate(y: CGFloat(Self.SIZE)).collides(other) ||
			translate(y: CGFloat(-Self.SIZE)).collides(other)
	}
}
