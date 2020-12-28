//
//  UIImage+utils.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
//

import Foundation

@objc
extension UIImage {

    func sprites(with size: CGSize) -> [UIImage]? {
        return (sprites(with: size, in: NSMakeRange(0, lroundf(MAXFLOAT))) as? [UIImage]) ?? []
    }
}
