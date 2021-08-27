//
//  QSDefineConstant.swift
//  JABaseUIKit
//
//  Created by JABase on 2021/8/16.
//

import Foundation

/**宏定义颜色**/
let TabBar_Color = UIColor.red

/*导航栏统一颜色*/
let NAVC_COLOR = UIColor.white

/**系统颜色颜色设置**/
let kWhiteColor     = UIColor.white
let kClearColor     = UIColor.clear // 清晰色
let kRedColor       = UIColor.red
let kBlackColor     = UIColor.black
let kDarkGrayColor  = UIColor.darkGray //深灰；暗灰；灰黑
let kLightGrayColor = UIColor.lightGray // 浅灰色
let kGrayColor      = UIColor.gray  // 灰色
let kGreenColor     = UIColor.green
let kBlueColor      = UIColor.blue
let kCyanColor      = UIColor.cyan  //. 蓝绿色
let kYellowColor    = UIColor.yellow
let kMagentaColor   = UIColor.magenta  //品红；洋红
let kOrangeColor    = UIColor.orange
let kPurpleColor    = UIColor.purple //紫色
let kBrownColor     = UIColor.brown

/*全屏宽*/
let kWidth    = UIScreen.main.bounds.size.width

/*全屏高*/
let kHeight    = UIScreen.main.bounds.size.height

/*获取随机颜色*/
func kRandomColor() -> UIColor {
    let red = CGFloat(arc4random()%256)/255.0
    let green = CGFloat(arc4random()%256)/255.0
    let blue = CGFloat(arc4random()%256)/255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

/*飞空对象转换成字符串*/
func getJSONString(obj:Any) -> String {
    
    if (!JSONSerialization.isValidJSONObject(obj)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: obj, options: []) as NSData
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)

    return JSONString! as String
}

/*JSON字符串转换成字典*/
func jsonToDictionary(jsonString:String) ->NSDictionary{
        
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! NSDictionary
    }
    return NSDictionary()
}

/*适配结构体*/
struct Fit {
    //是否为刘海屏
    private static let isBang:Bool = isFullScreen
    //导航栏高度
    static let N_H:CGFloat = isBang ? 88.0:64.0
    //tabbar高度
    static let B_H:CGFloat = isBang ? 83.0:49.0
    //底部安全区
    static let S_H:CGFloat = isBang ? 20.0:0.0
    //顶部状态栏高度（后有刘海）
    static let T_H:CGFloat = isBang ? 44.0:20.0
}
//判断是否为刘海屏
var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}

/**DEBUG环境下输出**/
func DLog<T>(message:T,other:String,fileName:String = #file,method:String = #function,lineNumber:Int = #line) -> Void {
    
    #if DEBUG
    if (other.count != 0) {
        print("\n==="+other+"===")
    }
        let logStr:String = (fileName as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    print("\n==当前控制器: \(UIViewController.current())\n     所在类: \(logStr)\n   使用方法: \(method)\n    所在行: [第\(lineNumber)行]\n   打印数据: \(message)\n")
    #endif
}
