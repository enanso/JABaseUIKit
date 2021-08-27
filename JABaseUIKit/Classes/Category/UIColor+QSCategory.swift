//
//  UIColor+QSCategory.swift
//  JABaseUIKit
//
//  Created by JABase on 2021/8/16.
//

import Foundation

extension UIColor {
    
    public convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    //暗黑色适配
    class func dark(light:Any,dark:Any) -> UIColor {
        
        let lightColor:UIColor = any(value: light)
        
        if #available(iOS 13.0, *) {
                        
            if UITraitCollection.current.userInterfaceStyle == .dark {
                //暗黑模式
                return any(value: dark)
            } else {
                //其他模式
                return lightColor
            }
        } else {
            // Fallback on earlier versions
            return lightColor
        }
    }
    //传参任意类型转颜色（支持UIColor、String、NSString）
    private class func any(value:Any) ->UIColor {
        var color:UIColor?
        if value is UIColor {
            color = (value as! UIColor)
        }
        else if value is String {
            color = UIColor(hex: (value as! String))
        }
        else if value is NSString {
            color = UIColor(hex: ((value as! NSString) as String))
        }
        return color!
    }
}
