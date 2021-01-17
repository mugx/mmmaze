//
//  Entity.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class Entity: Hashable {
	private var imageView: UIImageView?
	private var animations: [String: CABasicAnimation] = [:]

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

	static func == (lhs: Entity, rhs: Entity) -> Bool {
		lhs.imageView == rhs.imageView
	}

	init(frame: Frame) {
		self.frame = frame
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

	func set(image: UIImage) {
		imageView?.image = image
	}

	func set(images: [UIImage]) {
		imageView?.set(images: images)
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
}
