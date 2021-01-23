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

	var type: BaseEntityType { didSet { refreshImage() } }

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
	
	var velocity: CGPoint = .zero
	var speed: Float = 0
	var isDestroyable: Bool = false
	var isBlinking: Bool = false
	var lastDirection: Direction?
	private(set) var imageView: UIImageView?
	private var animations: [String: CABasicAnimation] = [:]

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

	init(type: BaseEntityType, frame: Frame = .zero, speed: Float = 0) {
		self.type = type
		self.frame = frame
		self.speed = speed
		self.imageView = UIImageView(frame: frame.rect)

		refreshImage()
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(imageView)
	}
	
	func collides(_ other: BaseEntity) -> Bool {
		return visible && frame.collides(other.frame)
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
	
	func refreshImage() {
		imageView?.setImages(for: type, with: color)
		if type == .coin {
			//¤ *
			imageView?.image = "¤".toImage()?.withTintColor(color)
		}
		//else if type == .player {
//			imageView?.image = "@".toImage()?.withTintColor(color)
////		} else if type == .wall {
////			// █,▓
////			imageView?.image = "█".toImage()?.withTintColor(color)
////		}
//		}else if type == .enemy {
//			imageView?.image = "X".toImage()?.withTintColor(color)
//		}
//		else {
//			imageView?.setImages(for: type, with: color)
//		}
	}
	
	// A moving tile can't match the TILE_SIZE or it collides with the borders, hence it doesn't move.
	// Instead we consider its frame as centered and resized of a speed factor so it has margin to move.
	func respawnAtInitialFrame() {
		velocity = .zero
		frame = Frame(row: Constants.STARTING_CELL.row, col: Constants.STARTING_CELL.col)
		frame = frame.resize(with: Float(Frame.SIZE) - Float(speed))
		frame = frame.centered()
	}
}
