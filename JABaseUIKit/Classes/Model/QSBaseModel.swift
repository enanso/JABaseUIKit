//
//  QSBaseModel.swift
//  JABaseUIKit
//
//  Created by JABase on 2021/8/27.
//

import Foundation

//struct QSBaseModel:Decodable, Encodable {
//    var name: String?
//    var age: Int?
//    var moneny: Double?
//    var books: [BookModel]?
//}
//
//struct BookModel:Decodable, Encodable {
//    var name: String?
//    var price: Double?
//}

@objcMembers

open class QSBaseModel: NSObject {
    public var sname: String?
    //夹带ISA地址的唯一标识符
    private var _isaId: String = "" {
        // newValue
        willSet{
            print("父类willSet被调用,newValue: \(newValue)")
        }
        // oldValue
        didSet{
            print("父类didSet被调用,oldValue: \(oldValue)")
        }
    }
    public var isaId:String?{
        set{
            _isaId = fooString(object: self)+"_"+newValue!
        }
        get{
            return _isaId
        }
    }
    open override class func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("===未定义当前key"+key)
    }
    open override class func setNilValueForKey(_ key: String) {
        print("===输入值为nil"+key)
    }
}


/*!
 缺点：
 1.继承后，父类属性自动转换模型失效，属性值为nil；
 2.对象属性重写实现，如果数据中不存在该字段，会直接奔溃，关键字作为字段时无法转换处理；
 */
open class BaseModel: QSBaseModel, Decodable, Encodable{

    public var name: String?
    public var age: Int?
    public var moneny: Double?
    public var books: [BookModel]?
    
    public var nick: String = "" {
        // newValue
        willSet{
            print("父类willSet被调用,newValue: \(newValue)")
        }
        // oldValue
        didSet{
            print("父类didSet被调用,oldValue: \(oldValue)")
        }
    }
}

open class BookModel: QSBaseModel, Decodable, Encodable{
    public var price: Double?
    public var desc: String?
    public var name: String?
}

//struct Person : Decodable {
//    let name : String
//    struct AnyCodingKey : CodingKey {
//        var stringValue: String
//        var intValue: Int?
//        init(_ codingKey: CodingKey) {
//            self.stringValue = codingKey.stringValue
//            self.intValue = codingKey.intValue
//        }
//        init(stringValue: String) {
//            self.stringValue = stringValue
//            self.intValue = nil
//        }
//        init(intValue: Int) {
//            self.stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//    init(from decoder: Decoder) throws {
//        var con = try! decoder.container(keyedBy: AnyCodingKey.self)
//        con = try! con.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(stringValue:"outer1"))
//        con = try! con.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(stringValue:"outer2"))
//        con = try! con.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(stringValue:"outer3"))
//        let name = try! con.decode(String.self, forKey: AnyCodingKey(stringValue:"name"))
//        self.name = name
//    }
//}
