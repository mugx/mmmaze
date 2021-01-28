//
//  BaseEntity.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class BaseEntity: Hashable {
	var type: BaseEntityType { didSet { refreshImage() } }
	var frame: Frame = .init(rect: .zero) { didSet { imageView?.frame = frame.rect } }
	
	var visible: Bool {
		get { imageView?.alpha == 1 && !(imageView?.isHidden ?? false)}
		set { imageView?.alpha = newValue ? 1 : 0; imageView?.isHidden = newValue}
	}

	var transform: CGAffineTransform {
		get { imageView?.transform ?? .identity }
		set { imageView?.transform = newValue }
	}

	private(set) var imageView: UIImageView?

	static func == (lhs: BaseEntity, rhs: BaseEntity) -> Bool {
		lhs.imageView == rhs.imageView
	}

	convenience init(type: BaseEntityType, position: Position) {
		self.init(type: type, frame: Frame(row: position.row, col: position.col))
	}
	
	convenience init(type: BaseEntityType, row: Int, col: Int) {
		self.init(type: type, frame: Frame(row: row, col: col))
	}

	deinit {
		imageView?.removeFromSuperview()
	}

	init(type: BaseEntityType, frame: Frame = .zero) {
		self.type = type
		self.frame = frame
		self.imageView = UIImageView(frame: frame.rect)

		defer {
			refreshImage()
		}
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(imageView)
	}

	// MARK: - Public

	func collides(_ other: BaseEntity) -> Bool {
		return visible && frame.collides(other.frame)
	}
	
	func explode(_ completion:(() -> ())? = nil) {
		imageView?.explode(completion)
	}
	
	func spin() {
		imageView?.layer.add(CABasicAnimation.spinAnimation(), forKey: "spin")
	}

	// MARK: - Private

	private func refreshImage() {
		imageView?.setImages(for: type, with: type.color)
	}
}
