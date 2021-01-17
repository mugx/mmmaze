//
//  BaseEntity.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class BaseEntity: Hashable {
	var color: UIColor {
		switch type {
		case .bomb, .hearth: return .red
		case .coin: return .yellow
		case .key: return .green
		case .time: return .magenta
		default: return .white
		}
	}

	private(set) var imageView: UIImageView?
	private var animations: [String: CABasicAnimation] = [:]
	var type: BaseEntityType { didSet { refresh() } }

	var visible: Bool {
		get { imageView?.alpha == 1 && !(imageView?.isHidden ?? false)}
		set { imageView?.alpha = newValue ? 1 : 0; imageView?.isHidden = newValue}
	}

	var transform: CGAffineTransform {
		get { imageView?.transform ?? .identity }
		set { imageView?.transform = newValue }
	}

	var frame: Frame = .init(rect: .zero) {
		didSet {
			imageView?.frame = frame.rect
		}
	}

	static func == (lhs: BaseEntity, rhs: BaseEntity) -> Bool {
		lhs.imageView == rhs.imageView
	}

	init(frame: Frame, type: BaseEntityType) {
		self.frame = frame
		self.type = type
		self.imageView = UIImageView(frame: frame.rect)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(imageView)
	}

	func add(to view: UIView) {
		guard let imageView = imageView else { return }
		view.addSubview(imageView)
	}
	
	func remove() {
		imageView?.removeFromSuperview()
	}

	func show(after time: TimeInterval = 1.0) {
		imageView?.isHidden = false
		imageView?.alpha = 0

		UIView.animate(withDuration: 0.5, delay: time) {
			self.imageView?.alpha = 1.0
		}
	}

	func explode(_ completion:(() -> ())? = nil) {
		imageView?.explode(completion)
	}

	func blink(_ duration: CFTimeInterval, completion: @escaping ()->()) {
		imageView?.blink(duration, completion: completion)
	}

	func spin() {
		let anim = CABasicAnimation.spinAnimation()
		imageView?.layer.add(anim, forKey: "spin")
		animations["spin"] = anim
	}

	func restoreAnimations() {
		animations.forEach({ (arg0) in
			imageView?.layer.add(arg0.value, forKey: arg0.key)
		})
	}

	func refresh() {
		imageView?.setImages(for: type, with: color)
	}
}
