//
//  UIDevice+Utils.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension UIDevice {
	var isSimulator: Bool {
		#if arch(i386) || arch(x86_64)
		return true
		#else
		return false
		#endif
	}
}
