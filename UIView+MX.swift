//
//  UIView+GT.swift
//  mugx
//
//  Created by mugx on 2017/02/21.
//  Copyright © 2017 mugx. All rights reserved.
//

import UIKit

extension UIView {
	
	@IBInspectable var borderWidth:CGFloat {
		get { return layer.borderWidth}
		set { self.layer.borderWidth = newValue }
	}
	
	@IBInspectable var borderColor:UIColor? {
		get { return layer.borderColor != nil ? UIColor(cgColor:layer.borderColor!) : nil }
		set { self.layer.borderColor = newValue?.cgColor }
	}
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	func convertViewToImage() -> UIImage? {
		let scale:CGFloat = UIScreen.main.scale
		let capturedScreen:UIImage?
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, scale);
		self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
		capturedScreen = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return capturedScreen
	}
	
	func x() -> CGFloat {
		return self.frame.origin.x
	}
	
	func y() -> CGFloat {
		return self.frame.origin.y
	}
	
	func width() -> CGFloat {
		return self.frame.size.width
	}
	
	func height() -> CGFloat {
		return self.frame.size.height
	}
	
	func hideByWidth(_ hidden:Bool) {
        self.hideView(hidden: hidden, attribute: NSLayoutConstraint.Attribute.width)
	}
	
	func hideByHeight(_ hidden:Bool) {
        self.hideView(hidden: hidden, attribute: NSLayoutConstraint.Attribute.height)
	}
	
	//MARK: Private functions
	
    func hideView(hidden:Bool, attribute:NSLayoutConstraint.Attribute) {
		if (hidden) {
            self.setConstraintValueBackup(attribute.rawValue == NSLayoutConstraint.Attribute.height.rawValue ? self.height() : self.width())
			self.setConstraintConstant(constant: 0, attribute: attribute)
			self.isHidden = true
		} else if (self.constraintValueBackup() > 0) {
			self.isHidden = false
			self.setConstraintConstant(constant: self.constraintValueBackup(), attribute: attribute)
		}
		self.superview?.setNeedsLayout()
	}
	
    func setConstraintConstant(constant:CGFloat, attribute:NSLayoutConstraint.Attribute) {
		let constraints:NSArray? = self.superview?.constraints as NSArray?
		let predicate:NSPredicate? = NSPredicate(format: "firstAttribute = %d && firstItem = %@", attribute.rawValue, self)
		let fillteredArray:NSArray? = constraints?.filtered(using: predicate!) as NSArray?
		
		if ((fillteredArray?.count)! > 0) {
			let constraint:NSLayoutConstraint = fillteredArray?.firstObject as! NSLayoutConstraint
			constraint.constant = constant
		} else {
            self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: constant))
		}
	}
	
	func constraintValueBackup() -> CGFloat {
		return self.layer.value(forKey: "constraintValueBackup") as? CGFloat ?? CGFloat(0)
	}
	
	func setConstraintValueBackup(_ value: CGFloat) {
		self.layer.setValue(value, forKey: "constraintValueBackup")
	}
}
