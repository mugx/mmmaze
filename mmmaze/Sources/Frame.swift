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

class Frame {
	let row: Int
	let col: Int
	private(set) var _frame: CGRect = .zero
	private static let SIZE: Int = 32

	init(row: Int, col: Int) {
		self.row = row
		self.col = col
		_frame = CGRect(x: col * Frame.SIZE, y: row * Frame.SIZE, width: Frame.SIZE, height: Frame.SIZE)
	}

	private init(rect: CGRect) {
		let x = Float(rect.origin.x)
		let y = Float(rect.origin.x)
		let width = Float(rect.size.width)
		let height = Float(rect.size.height)
		self.row = Int(round(y / height) * height)
		self.col = Int(round(x / width) * width)
		_frame = rect
	}

	func collides(_ other: Frame) -> Bool {
		_frame.intersects(other._frame)
	}

	func collides(_ other: CGRect) -> Bool {
		_frame.intersects(other)
	}

	func translate(x: Float = 0, y: Float = 0) -> Frame {
		let new_x = _frame.origin.x + CGFloat(x)
		let new_y = _frame.origin.y + CGFloat(y)
		let rect = CGRect(x: new_x, y: new_y, width: _frame.width, height: _frame.height)
		return Frame(rect: rect)
	}

	func translate(x: Int = 0, y: Int = 0) -> Frame {
		let new_x = _frame.origin.x + CGFloat(x)
		let new_y = _frame.origin.y + CGFloat(y)
		let rect = CGRect(x: new_x, y: new_y, width: _frame.width, height: _frame.height)
		return Frame(rect: rect)
	}

	func tiled() -> CGRect {
		let size = CGFloat(Frame.SIZE)
		let x = Int(round(_frame.origin.x / size) * size)
		let y = Int(round(_frame.origin.y / size) * size)
		return CGRect(x: x, y: y, width: Int(size), height: Int(size))
	}

	func follow(_ pivot: UIView) {
		_frame = CGRect(
			x: _frame.size.width / 2.0 - pivot.frame.origin.x,
			y: _frame.size.height / 2.0 - pivot.frame.origin.y,
			width: _frame.size.width,
			height: _frame.size.height
		)
	}

	func distance(to rect: CGRect) -> CGFloat {
		let center1 = CGPoint(x: _frame.midX, y: _frame.midY)
		let center2 = CGPoint(x: rect.midX, y: rect.midY)
		let horizontalDistance = center2.x - center1.x
		let verticalDistance = center2.y - center1.y
		let distance = sqrt(pow(horizontalDistance, 2) + pow(verticalDistance, 2))
		return distance
	}

	func isNeighbour(of frame: CGRect) -> Bool {
		return
			collides(translate(x: Frame.SIZE)) ||
			collides(translate(x: -Frame.SIZE)) ||
			collides(translate(y: Frame.SIZE)) ||
			collides(translate(y: -Frame.SIZE))
	}
}
