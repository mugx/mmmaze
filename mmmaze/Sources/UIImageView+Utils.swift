//
//  UIImageView+Utils.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension UIImageView {
	static let ANIM_DURATION = 1.0
	static let SUB_TILE_DIVIDER_SIZE: CGFloat = 5.0

	func setImages(for type: BaseEntityType, with color: UIColor = .white) {
		let images = UIImage(named: type.rawValue)!.sprites()
		animationImages = images.map { $0.mask(with: color)! }
		animationDuration = 0.4
		animationRepeatCount = 0
		startAnimating()
	}

	func blink(_ duration: CFTimeInterval, completion: @escaping ()->()) {
		let repeatCount: Float = 10
		let flash = CABasicAnimation(keyPath: "opacity")
		flash.duration = duration / Double(repeatCount)
		flash.fromValue = 1
		flash.toValue = 0.1
		flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		flash.autoreverses = true
		flash.repeatCount = repeatCount
		layer.add(flash, forKey: nil)

		DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
			completion()
		}
	}

	func explode(_ completion:(() -> ())? = nil) {
		guard let image = self.image ?? self.animationImages?.first else { return }
		self.animationImages = nil
		self.image = nil
		
		let originalW = image.size.width / Self.SUB_TILE_DIVIDER_SIZE
		let originalH = image.size.width / Self.SUB_TILE_DIVIDER_SIZE
		let cols = Int(floor(image.size.width / originalW))
		let rows = Int(floor(image.size.height / originalH))

		// preparing sub tiles 
		for x in 0 ... cols {
			for y in 0 ... rows {
				let frame = CGRect(
					x: CGFloat(x) * originalW,
					y: CGFloat(y) * originalH,
					width: originalW,
					height: originalH)

				let subTile = UIImageView(image: image.crop(with: frame))
				subTile.frame = frame
				addSubview(subTile)
			}
		}

		// starting to animate the sub tiles 
		let subviews = self.subviews
		for subTile in subviews {
			UIView.animate(withDuration: Self.ANIM_DURATION, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
				let splat_x = Bool.random() ? 1 : -1 * CGFloat.random(in: 0 ..< 50)
				let splat_y = Bool.random() ? 1 : -1 * CGFloat.random(in: 0 ..< 50)
				subTile.frame = subTile.frame.offsetBy(dx: subTile.frame.origin.x + splat_x, dy: subTile.frame.origin.y + splat_y)
				subTile.alpha = 0
			} completion: { _ in
				subTile.removeFromSuperview()
				self.isHidden = true

				if self.subviews.isEmpty {
					completion?()
				}
			}
		}
	}
}
