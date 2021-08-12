//
//  QSWebViewController.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/12.
// swift版 -- 基础Web控制器

import UIKit
import WebKit
import SnapKit
/**
JS交互:https://www.jianshu.com/p/dadd1bd83752
 */

/**
 添加WeakScriptMessageDelegate文件,用其作为与JS交互时的代理,防止出现ViewController不释放的问题.
 */
///内存管理,使用delegate类防止ViewController不释放
class WSKWeakScriptMessageDelegate: NSObject,WKScriptMessageHandler {
    weak var scriptDelegate:WKScriptMessageHandler!
    init (scriptDelegate:WKScriptMessageHandler) {
        super.init()
        self.scriptDelegate = scriptDelegate
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.scriptDelegate.userContentController(userContentController, didReceive: message)
    }
}

public class QSWebViewController: QSViewController {
    
    // WKWebView
    lazy var webView: WKWebView = {
         ///偏好设置
         let preferences = WKPreferences()
         preferences.javaScriptEnabled = true

         let configuration = WKWebViewConfiguration()
         configuration.preferences = preferences
         configuration.selectionGranularity = WKSelectionGranularity.character
         configuration.userContentController = WKUserContentController()
        
        configuration.allowsInlineMediaPlayback = true
        
         // 给webview与swift交互起名字，webview给swift发消息的时候会用到
        configuration.userContentController.add(WSKWeakScriptMessageDelegate(scriptDelegate: self), name: "logger")
        configuration.userContentController.add(WSKWeakScriptMessageDelegate(scriptDelegate: self), name: "redResponse")
        configuration.userContentController.add(WSKWeakScriptMessageDelegate(scriptDelegate: self), name: "blueResponse")
        configuration.userContentController.add(WSKWeakScriptMessageDelegate(scriptDelegate: self), name: "greenResponse")
        configuration.userContentController.add(WSKWeakScriptMessageDelegate(scriptDelegate: self), name: "yellowResponse")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        //监听加载进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(webView)
         // 让webview翻动有回弹效果
         webView.scrollView.bounces = false
         // 只允许webview上下滚动
         webView.scrollView.alwaysBounceVertical = true
         webView.navigationDelegate = self
         return webView
     }()
    // 进度条
    public lazy var progressView:UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = UIColor.orange
        progressView.trackTintColor = UIColor.white
        progressView.progress = 0.01 //设置初始值，防止网页加载过慢时没有进度
        self.view.addSubview(progressView)
        return progressView
    }()
    //不展示后缀按钮
    @objc public var url: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.url!.count > 0 {
            initInterface()
            let request = URLRequest(url: URL(string: self.url!)!)
            webView.load(request)
        }
    }
    
    /// 布局UI
    private func initInterface() -> () {
        //webView布局
        self.webView.snp.makeConstraints{(make) in
            make.left.right.top.bottom.equalTo(0)
        }
        //progressView布局
        self.progressView.snp.makeConstraints{(make) in
            make.left.top.equalTo(0)
            make.height.equalTo(3)
            make.right.equalTo(50)
        }
    }
}

extension QSWebViewController: WKNavigationDelegate{
    
    // 监听网页加载进度
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.progressView.progress = Float(self.webView.estimatedProgress)
        print("===加载进度===")
        print(self.webView.estimatedProgress)
    }
    
    // 页面开始加载时调用
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("===开始加载...===")
    }
    
    // 当内容开始返回时调用
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        print("===当内容开始返回...===")
    }
    
    // 页面加载完成之后调用
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        //DLog(message: "页面加载完成...", other: "")
        /// 获取网页title
        self.title = self.webView.title
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.isHidden = true
        }
        //获取当前网页的html
        webView.evaluateJavaScript("document.documentElement.innerHTML", completionHandler: nil)

//        let attribstr = try! NSAttributedString.init(data:(str?.data(using: String.Encoding.unicode))! , options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        
    }
    
    // 页面加载失败时调用
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        //DLog(message: "页面加载失败...", other: "")
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        /// 弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
//            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
 
}
extension QSWebViewController: WKScriptMessageHandler{
    ///接收js调用方法
    public func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        ///在控制台中打印html中console.log的内容,方便调试
        let body = message.body
        if message.name == "logger" {
            print("JS log:\(body)")
            return
        }
        ///message.name是约定好的方法名,message.body是携带的参数
        switch message.name {
        case "redResponse":
            ///不接收参数时直接不处理message.body即可,不用管Html传了什么
            //redRequest()
            break
        case "blueResponse":
            //blueRequest(string: message.body as! String)
            break
        case "greenResponse":
            //greenRequest(int: message.body as! Int)
            break
        case "yellowResponse":
            //yellowRequest(array: message.body as! [String])
            break
        default:
            break
        }
    }
}
