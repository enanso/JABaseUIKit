//
//  NSObject+QSCategory.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/16.
//

import Foundation

extension NSObject {
    
    //读取对象指针首地址
    @objc public func fooString(object: Any) -> String {
        guard !(object is NSNull) else {
            return ""
        }
        return String(format: "%p", object as! CVarArg);
    }
}

// MARK: ============= 自定义本地资源库读取 =============
extension Bundle {

    // 定义一个静态变量JABaseUIKit，用于获取项目本地的Bundle文件：XXX.bundle。
    static var JABaseUIKitBundle: Bundle{
        let aimBundlePath = Bundle.main.path(forResource:"JABaseUIKit", ofType:"bundle")
        let aimBundle = Bundle.init(path: aimBundlePath!)
        return aimBundle!
    }
    
    // 内部返回按钮图片
    static var leftImage: UIImage{
        return (UIImage.init(contentsOfFile: self.JABaseUIKitBundle.path(forResource: "st_back@2x", ofType: "png")!)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))!
    }

    // 根据名称读取自定义Bundle中的图片
    static func image(name:String) -> UIImage{
        
        let path = self.JABaseUIKitBundle.path(forResource: name, ofType: "png")
        
        if ((path?.count) != nil) {
            return (UIImage.init(contentsOfFile: self.JABaseUIKitBundle.path(forResource: name, ofType: "png")!)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))!
        }else {
            print("无此图片")
            return UIImage()
        }
    }
    
    // 类方法
    class func localizedString(forKey key: String) -> String {
        return self.localizedString(forKey: key, value: nil)
    }

    // 参数value为可选值，可以传值为nil。
    class func localizedString(forKey key: String, value: String?) -> String {
        var language = Locale.preferredLanguages.first!
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            language = "zh-Hans"
        } else {
            language = "en"
        }

        let bundle = Bundle.init(path: self.JABaseUIKitBundle.path(forResource: language, ofType: "lproj")!)
        let v = bundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: v, table: nil)
    }
}
