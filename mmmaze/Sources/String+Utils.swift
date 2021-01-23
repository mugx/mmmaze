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

	func toImage() -> UIImage? {
		let attr: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.red,
			.font: UIFont(name: Constants.FONT_FAMILY, size: 32)!
		]
		let size = CGSize(width: 32, height: 32)
		let offset = 3
		return UIGraphicsImageRenderer(size: size).image { _ in
			(self as NSString).draw(in: CGRect(origin: CGPoint(x: offset, y: -offset), size: size), withAttributes: attr)
		}
	}
}
