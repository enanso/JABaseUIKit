//
//  JATestCollectionViewController.swift
//  JABaseUIKit_Example
//
//  Created by JABase on 2021/8/20.
//  Copyright © 2021 lanmemory@163.com. All rights reserved.
//

import UIKit
import JABaseUIKit
class JATestCollectionViewController: QSCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arr: [String] = ["线程安全问题","defer使⽤场景","throws 和 rethrows 的⽤法","lazy的作⽤","Swift闭包详解","⾃动闭包","Map函数","flatMap函数","CompactMap函数","filter函数","for...Each","Reduce 函数"]
        
        self.space = 5.0
        
        let dic: [String: Any] = [
            "sname": "张三父亲",
            "name": "张三",
            "age": 25,
            "money": 1000.00,
            "id": 9572,
            "books": [
                ["name": "三国演义",
                 "author": "罗贯中",
                 "desc": "《三国演义》通过集中描绘三国时代各封建统治集团之间的政治、军事、外交斗争，揭示了东汉末年社会现实的动荡和黑暗，谴责了封建统治者的暴虐，反映了人民的苦难，表达了人民呼唤明君、呼唤安定的强烈愿望。",
                 "price": 9.9],
                ["name": "水浒传",
                 "author": "宋朝统治者腐朽凶残，宋江、鲁智深等众多好汉最终都因为种种不同原因而被迫在梁山落草为寇，揭杆起义。他们举起义旗，打着替天行道，劫富济贫的口号，杀遍大江南北，沉重地打击了反动统治者的嚣张气焰，张扬了人民群众的神勇斗志，干出了一番轰轰烈烈的大事业。",
                 "desc": "施耐庵",
                 "price": 29.9],
                ["name": "西游记",
                 "author": "吴承恩",
                 "desc": "孙悟空与猪八戒、沙僧一起保护唐僧取经。一路上历尽千辛万苦，战胜形形色色的妖魔鬼怪，经过九九八十一难，功成圆满，终成正果 ",
                 "price": 39.9],
                ["name": "红楼梦",
                 "author": "曹雪芹、高鹗",
                 "desc": "《红楼梦》一书，以贾宝玉、林黛玉和薛宝钗的爱情悲剧为主线，通过对“贾、史、王、薛”四大家族荣衰的描写，展示了广阔的社会生活视野，森罗万象，囊括了多姿多彩的世俗人情。人们称《红楼梦》内蕴着一个时代的历史容量，是封建末世的百科全书。",
                 "price": 19.9]
            ]
        ]
        
//        // 只读"books"字段
//        if let books = dic["books"] as? [[String:Any]] {
//            //第一种
//            let model1 = QSDecoder.decode(type: BookModel.self, array: books)
//            print(model1 ?? "方法一不存在")
//            //第二种
//            let model2 = [BookModel].decode(array: books)
//            print(model2 ?? "方法二不存在")
//        }

        //第一种
//        let model1: BaseModel = QSDecoder.decode(type: BaseModel.self, param: dic)!
//        print(model1.isaId ?? "方法一不存在")
        //第二种
        let model2 = BaseModel.decode(dictionary: dic)
        print(model2 ?? "方法二不存在")
        
        dataSource.addObjects(from: arr)
    }
}

extension JATestCollectionViewController{

    // cell点击事件响应
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = getData(indexPath: indexPath)
        guard !(value is NSNull) else {
            return
        }
        testSwift(value: value)
    }
    
    private func testSwift(value: Any)->Void{
        guard !(value is String) else {
            return
        }
        let str: String = value as! String
        
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
