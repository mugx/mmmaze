//
//  UIImage+utils.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension UIImage {
	func sprites(with size: Double) -> [UIImage]? {
		guard let cgImage = self.cgImage else { return [] }

		var images = [UIImage]()
		let width = cgImage.width

		stride(from: 0, to: width, by: Int(size)).forEach { i in
			let rect = CGRect(origin: CGPoint(x: i, y: 0), size: CGSize(width: size, height: size))
			if let sprite = cgImage.cropping(to: rect) {
				images.append(UIImage(cgImage: sprite))
			}
		}
		return images
	}

	func crop(with rect: CGRect) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
		draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
		let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return croppedImage!
	}
}
