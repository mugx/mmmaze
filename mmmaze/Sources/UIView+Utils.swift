//
//  UIView+Utils.swift
//  mmmaze
//
//  Created by mugx on 28/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension UIView {
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable var localization: String {
		get {
			return description
		}
		set {
			if let button = self as? UIButton {
				button.setTitle(newValue.localized, for: .normal)
			}

			if let label = self as? UILabel {
				label.text = newValue.localized
			}
		}
	}

	open override func awakeFromNib() {
		super.awakeFromNib()

		if let button = self as? UIButton, button.buttonType == .system {
			button.titleLabel?.font = UIFont(name: Constants.FONT_FAMILY, size: button.titleLabel?.font.pointSize ?? 0)!
		}

		if let label = self as? UILabel {
			label.font = UIFont(name: Constants.FONT_FAMILY, size: label.font.pointSize)!
		}
	}

	func follow(_ other: BaseEntity) {
		frame = CGRect(
			x: frame.size.width / 2.0 - other.frame.rect.origin.x,
			y: frame.size.height / 2.0 - other.frame.rect.origin.y,
			width: frame.size.width,
			height: frame.size.height
		)
	}

	func flash() {
		UIView.animate(withDuration: 0.15, delay: 0, options: [.repeat, .autoreverse], animations: {
			self.alpha = 0.4
		}) { (finished) in
			self.alpha = 1.0
		}
	}
}
