//
//  UIImage+utils.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension UIImage {
	func sprites(size: Double = Double(Frame.SIZE)) -> [UIImage] {
		var images = [UIImage]()
		let width = cgImage!.width

		stride(from: 0, to: width, by: Int(size)).forEach { i in
			let rect = CGRect(origin: CGPoint(x: i, y: 0), size: CGSize(width: size, height: size))
			if let sprite = cgImage!.cropping(to: rect) {
				images.append(UIImage(cgImage: sprite))
			}
		}
		return images
	}

	func mask(with color: UIColor) -> UIImage? {
		let maskImage = cgImage!

		let width = size.width
		let height = size.height
		let bounds = CGRect(x: 0, y: 0, width: width, height: height)

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

		context.clip(to: bounds, mask: maskImage)
		context.setFillColor(color.cgColor)
		context.fill(bounds)

		if let cgImage = context.makeImage() {
			let coloredImage = UIImage(cgImage: cgImage)
			return coloredImage
		} else {
			return nil
		}
	}

	func crop(with rect: CGRect) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
		draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
		let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return croppedImage!
	}
}
