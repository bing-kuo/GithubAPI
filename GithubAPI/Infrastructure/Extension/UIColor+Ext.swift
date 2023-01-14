//
//  UIColor+Ext.swift
//  GithubAPI
//
//  Created by Bing Guo on 2023/1/8.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 1.0, "Invalid alpha component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(red: (rgb >> 16) & 0xFF,
                  green: (rgb >> 8) & 0xFF,
                  blue: rgb & 0xFF,
                  alpha: alpha)
    }
}

extension UIColor {
    static let primary = UIColor(rgb: 0x577C8A)
    static let secondary = UIColor(rgb: 0xD05A6E)

    func lighter(_ offset: CGFloat = 0.5) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + offset, 1.0),
                           green: min(green + offset, 1.0),
                           blue: min(blue + offset, 1.0),
                           alpha: alpha)
        }

        return self
    }
}
