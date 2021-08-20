//
//  UIViewController+QSCategory.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/16.
//

import Foundation

private var KTYPE_IN_VC_KEY: String = "KTYPE_IN_VC_KEY"

private let onceToken = "Method Swizzling"

public extension UIViewController{

    //页面跳转方式枚举
    enum JumpType {
        case push,//导航栏直接push
        adNavc,//添加导航栏后模态
        nonPush,//直接模态过来,无导航栏
        nonJump,//非页面跳转，只被添加到容器内(存在导航栏)
        nonNavc//非页面跳转，只被添加到容器内(无导航栏)
        
        //加导航栏去往下一页
        func naveToNextPage(vc:UIViewController) -> JumpType {
            
            if vc.type == .push || vc.type == .adNavc {
                return .push//有导航栏的情况
            }else{
                return .adNavc//无导航栏的情况
            }
        }
        
        //返回上一页的方法
        func backWithPop(vc:UIViewController) -> Void{
            
            //非在容器内的情况
            if vc.type != .nonJump || vc.type != .nonNavc {
                
                if vc.type == .push {
                    vc.navigationController?.popViewController(animated: true)//直接push的情况
                }else{
                    vc.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //页面跳转扩展属性(利用runtime属性重写get和set方法)
    var type: JumpType?{
        get {
            return (objc_getAssociatedObject(self, &KTYPE_IN_VC_KEY) as? JumpType)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &KTYPE_IN_VC_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /**获取当前根视图控制器**/
    static func root() -> UIViewController{
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!
        return window.rootViewController!
    }
    
    /**获取当前控制器**/
    static func current() -> UIViewController{
        //获取根视图
        var currentViewController:UIViewController = root()
        
        let runLoopFind = true
        
        while (runLoopFind) {
            
            if ((currentViewController.presentedViewController) != nil) {
                
                currentViewController = currentViewController.presentedViewController!
                
            } else if (currentViewController.isKind(of: UINavigationController.classForCoder())) {
                //判断当前根视图是否为导航栏控制器
                let navigationController:UINavigationController = currentViewController as! UINavigationController
                //取出最后加入子控制器
                currentViewController = navigationController.children.last!
                
            } else if (currentViewController.isKind(of: UITabBarController.classForCoder())) {
                //判断当前根视图是否为容器控制器
                 let tabBarController:UITabBarController = currentViewController as! UITabBarController
                //取出最后加入子控制器
                currentViewController = tabBarController.selectedViewController!
                
            } else {
                //子控制器数量
                let childViewControllerCount:NSInteger = currentViewController.children.count
                
                if (childViewControllerCount > 0) {
                    
                    //取出最后加入子控制器
                    currentViewController = currentViewController.children.last!
                    
                    return currentViewController;
                    
                } else {
                    
                    return currentViewController;
                }
            }
            
        }
        
        return currentViewController;
    }
    
    
    /**
     用于获取父亲控制器
     @ parameter vc:  当前的控制器
     @ parameter target: 要获取的父亲控制器的类型
     @ return: 返回父亲控制器
     */
    static func returnFatherObject(vc: UIViewController,target:AnyClass )-> AnyObject{
        var responser = vc.next
        var ExitResponer = true
        while(ExitResponer == true){
            //print("类型为",responser?.classForCoder)
            if( responser?.classForCoder != target && responser != nil){
                responser = responser!.next
            }else{
                ExitResponer = false
            }
        }
        return responser!
    }
    
    //自定义页面跳转方法
     func toNewPage(vc:UIViewController,type:JumpType?,animated:Bool,completion: (() -> Void)? = nil) -> Void {
        
        //页面跳转方式
        switch type {
        case .push?:do {
            
            self.navigationController!.pushViewController(vc, animated: animated)
            }
        case .adNavc?:do {
            let navc:UINavigationController = UINavigationController(rootViewController: vc)
            self.present(navc, animated: true, completion: completion)
            }
        case .nonPush?:do {
            self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(vc, animated: true, completion: completion)
            }
        default:do {}
        }
    }
}
