//
//  JATestCollectionViewController.swift
//  JABaseUIKit_Example
//
//  Created by Qiyeyun7 on 2021/8/20.
//  Copyright © 2021 lanmemory@163.com. All rights reserved.
//

import UIKit
import JABaseUIKit
class JATestCollectionViewController: QSCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let arr: [String] = ["线程安全问题","defer使⽤场景","throws 和 rethrows 的⽤法","lazy的作⽤","Swift闭包详解","⾃动闭包","Map函数","flatMap函数","CompactMap函数","filter函数","for...Each","Reduce 函数"]
        dataSource.addObjects(from: arr)
    }
}

extension JATestCollectionViewController{

    // cell点击事件响应
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = getData(indexPath: indexPath)
        guard !(title is NSNull) else {
            return
        }
        testSwift(str: title as! String)
    }
    
    private func testSwift(str: String)->Void{
        switch str {
        case "线程安全问题": do {
            print("============================\n")
            print("解读：对于同一数组进行异步操作，删除操作影响读取，导致越界crash;\n修复：[teachers] in 拷贝一份新的组teachers;\n结论：当线程会 copy 值类型内容时是线程安全的，其他情况会存在线程不安全的隐患")
            print("\n============================")
            var teachers = ["A", "B", "C"]
            let queue = DispatchQueue.global()
            //异步读取操作
            /*!
             解读：对于同一数组进行异步操作，删除操作影响读取，导致越界crash
             修复：[teachers] in 拷贝一份新的组teachers
             结论：当线程会 copy 值类型内容时是线程安全的，其他情况会存在线程不安全的隐患
             */
            queue.async {[teachers] in
                let count = teachers.count
                for index in 0..<count {
                    print("\(teachers[index])")
                    //模拟休眠1s
                    Thread.sleep(forTimeInterval: 1)
                }
            }
            //异步移除元素操作
            queue.async {
                //模拟休眠0.5s
                Thread.sleep(forTimeInterval: 0.5)
                teachers.remove(at: 0)
            }
        }
        case "defer使⽤场景": do {
            print("============================\n")
            print("解读：defer {} ⾥的代码会在当前代码块返回的时候执⾏，⽆论当前代码块是从哪个分⽀ return 的， 即使程序抛出错误，也会执⾏;\n如果多个 defer 语句出现在同⼀作⽤域中，则它们出现的顺序与它们执⾏的顺序相反，也就是先出现的后执⾏")            
            print("\n=============面试题1===============")
            var a = 1
            func add() -> Int {
                defer {
                    a = a + 1
                    print("内部："+String(a))
                }
                print("返回值："+String(a))
                return a
            }
            let tmp = add()
            print("函数调用："+String(tmp))
        }
        
        case "": do {}
        case "": do {}
        case "": do {}
        default: break
        }
    }
}
