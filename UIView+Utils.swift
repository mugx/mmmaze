//
//  UIView+Utils.swift
//  mmmaze
//
//  Created by mugx on 28/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

extension UIView {
	@IBInspectable var localization: String {
		get {
			return description
		}
		set {
			(self as? UIButton)?.setTitle(newValue.localized, for: .normal)
			(self as? UILabel)?.text = newValue.localized
		}
	}
}
