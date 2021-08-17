//
//  QSViewController.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/12.
// swift版 -- 基础控制器

import UIKit

public class QSViewController: UIViewController {
    
    //JAViewController.swift
    typealias BackActionBlock = (_ selected:Bool)->Bool;
    var backBlock : BackActionBlock?;
    
    //重写get和set方法
    private var _image: String?
    //图片名称
    var image: String? {
        get {
            return _image
        }
        set {
            //判断是否发生值得变化
            if _image != newValue {
                _image = newValue
                //返回按钮图片
                let name = UIImage.init(named: newValue!)?.scaleToSize(w: 35, h: 35)
                if (name != nil) {
                    self.leftBtn.setImage(name, for: UIControl.State.normal)
                }
            }
        }
    }
    
    /**懒加载左侧返回按钮**/
    private lazy var leftBtn : UIButton = {
        
        let leftBtn = UIButton(type: UIButton.ButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        //返回按钮图片
        let name = UIImage.init(named: "st_back")?.scaleToSize(w: 35, h: 35)
        
        leftBtn.setImage(name, for: UIControl.State.normal)
        //监听方法
        leftBtn.addTarget(self,action:#selector(backToLastPage),for:.touchUpInside)
        return leftBtn
    }()
    /**视图加载完成**/
    public override func viewDidLoad() {
        super.viewDidLoad()

        //查询页面跳转类型
        self.checkType()
        //默认背景色
        self.view.backgroundColor = UIColor.dark(light: "ffffff", dark: "1e1e1e")
        
        //创建子视图
        self.createSub()
    }

    /*处理type类型结果*/
    private func checkType()->Void{
        //非空情况，不做处理，外界优先级最高
        if (self.type != nil) {
            //判断跳转过来是否拥有导航栏
            if self.type == JumpType.push || self.type == JumpType.adNavc || self.type == JumpType.nonJump {
                //底部素线隐藏（组合使用）
                self.navigationController!.navigationBar.isTranslucent = false
                //隐藏导航栏底部素线
                self.navigationController?.navigationBar.shadowImage = UIImage()
            }
            return
        }
        
        //判断导航栏是否展示
        if ((self.navigationController?.visibleViewController) != nil) {
            
            //底部素线隐藏（组合使用）
            self.navigationController!.navigationBar.isTranslucent = false
            
            //读取容器中的VC集合
            let vcs:NSArray = self.navigationController!.viewControllers as NSArray
            //隐藏导航栏底部素线
            self.navigationController?.navigationBar.shadowImage = UIImage()
            //导航栏控制器的子VC数量大于1时，为push
            if vcs.count > 1 {

                //记录为直接push
                self.type = JumpType.push;
            }else{
                //加导航控制器模态过来数据，或者为第一级数据
                if ((self.navigationController?.parent?.children.count) != nil) {
                    
                    self.type = JumpType.nonJump//非跳转过
                }else{
                    self.type = JumpType.adNavc//添加导航栏跳过
                }
            }
        }else{
            
            //加导航控制器模态过来数据，或者为第一级数据
            if ((self.parent?.children.count) != nil) {
                self.type = JumpType.nonNavc//非跳转过来，且无导航栏
            }else{
                self.type = JumpType.nonPush//直接模态过来,无导航栏
            }
        }
    }
    
    /**创建子视图**/
    func createSub() -> Void {
        switch self.type {
            case .push?,.adNavc?:do {
                let backButtonItem = UIBarButtonItem(customView: self.leftBtn)
                self.navigationItem.leftBarButtonItem = backButtonItem
            }
            case .nonPush?:do {
                self.leftBtn.frame = CGRect(x: 15, y: Fit.N_H - self.leftBtn.h, width: self.leftBtn.w, height: self.leftBtn.h)
                self.view.addSubview(self.leftBtn)
            }
            default: break
        }
    }
    
    /*返回上一页面*/
    @objc private func backToLastPage() -> Void {
        
        if (self.backBlock != nil) {
            let canBack = self.backBlock?(false)
            if canBack == false {
                return
            }
        }
        switch self.type {
            case .push?:do {//直接模态过来
                self.navigationController?.popViewController(animated: true)
                }
            case .adNavc?,.nonPush?:do {//添加导航栏后模态或者直接模态
                self .dismiss(animated: true, completion: nil)
                }
            default: break
        }
    }

    deinit {
        
        #if DEBUG
        //获取工程名字
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        print("==销毁类: \(NSStringFromClass(self.classForCoder).replacingOccurrences(of: namespace+".", with: ""))")
        #endif
    }
}
