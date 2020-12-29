//
//  UIImageView+Utils.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

extension UIImageView {
	@objc func blink(_ duration: CFTimeInterval, completion: @escaping ()->()) {
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
}
