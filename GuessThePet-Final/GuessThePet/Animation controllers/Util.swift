//
//  Util.swift
//  GuessThePet
//
//  Created by Edward Ding on 9/19/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

extension UIImage {
    class func renderImage(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderedImage
    }
}
