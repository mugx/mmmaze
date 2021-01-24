//
//  String+Utils.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension String {
	var localized: String {
		NSLocalizedString(self, comment: "")
	}

	func toImage() -> UIImage {
		let frame = CGRect(origin: .zero, size: CGSize(width: 32, height: 32))
		let nameLabel = UILabel(frame: frame)
		nameLabel.text = self
		nameLabel.textAlignment = .center
		nameLabel.font = UIFont(name: Constants.FONT_FAMILY, size: 32)!
		UIGraphicsBeginImageContext(frame.size)
		let currentContext = UIGraphicsGetCurrentContext()!
		nameLabel.layer.render(in: currentContext)
		return UIGraphicsGetImageFromCurrentImageContext()!
	}
}
