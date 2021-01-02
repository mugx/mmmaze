//
//  CABasicAnimation+Utils.swift
//  mmmaze
//
//  Created by mugx on 30/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

extension CABasicAnimation {
	static func flipAnimation() -> CABasicAnimation {
		let anim = CABasicAnimation(keyPath: "transform.rotation.y")
		anim.fromValue = 0
		anim.toValue = 360 * Double.pi / 180
		anim.duration = 3.0
		anim.repeatCount = MAXFLOAT
		return anim
	}

	static func spinAnimation() -> CABasicAnimation {
		let anim = CABasicAnimation(keyPath: "transform.rotation")
		anim.fromValue = 0
		anim.toValue = 360 * Double.pi / 180
		anim.duration = 3.0
		anim.repeatCount = MAXFLOAT
		return anim
	}
}
