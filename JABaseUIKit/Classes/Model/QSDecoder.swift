//
//  QSDecoder.swift
//  JABaseUIKit
//
//  Created by JABase on 2021/8/27.
//  数据与模型相互转换工具类：参考https://www.jianshu.com/p/b058369efd09

import Foundation
import SwiftyJSON

//1.1 定义一个QSDecoder类型，用于字典、数组转换成模型
public struct QSDecoder {
    
    //TODO:转换模型(单个对象)
    public static func decode<T>(type:T.Type, param: [String:Any]) ->T? where T: Decodable {
        // 转JSON
        guard let jsonData = self.getJsonData(with: param) else {
            return nil
        }
        // 构建模型
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            return nil
        }
        return model
    }
    
    //多个对象
    public static func decode<T>(type:T.Type, array: [[String:Any]]) -> [T]? where T: Decodable {
        // 转JSON
        guard let data = self.getJsonData(with: array) else {
            return nil
        }
        // 构建模型
        guard let models = try? JSONDecoder().decode([T].self, from: data) else {
            return nil
        }
        return models
    }
    
    // 转JSON
    public static func getJsonData(with param:Any) ->Data? {
        // 判断对象是否可序列化
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        // JSON序列化转换成二进制数据
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}

//2.1 定义一个QSEncoder类型，用于模型转换成字典、数组
struct QSEncoder {
    
    public static func encoder<T>(toString model: T) ->String? where T: Encodable {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        guard let jsonStr = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonStr
    }
    
    public static func encoder<T>(toDictionary model:T) -> [String:Any]? where T: Encodable {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] else {
            return nil
        }
        return dict
    }
}

///1.2 延展Decodable，用于字典、数组转换成模型
public extension Decodable {
    
    /// dictionary -> 模型，用法: Model.decode(dic)
    static func decode(dictionary: [String:Any]) ->Self? {
        guard let data = self.getJsonData(with: dictionary) else {
            return nil
        }
        guard let model = try?JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return model
    }
    
    /// array -> 模型，用法:[Model].decode(array)
    static func decode(array: [[String:Any]]) ->Self? {
        guard let data = self.getJsonData(with: array) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return model
    }

    /// JSON -> 模型
    /// 如果未使用SwiftyJSON，请注释或者删掉以下方法
    /*!
     如果是单个，则 Model.decode(json)
     如果是多个，则 [Model].decode(json)
     */

    static func decode(json:JSON) -> Self? {
        guard let data = try? json.rawData() else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return model
    }
    
    static func getJsonData(with param:Any) -> Data? {
        // 判断对象是否可序列化
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        // JSON序列化转换成二进制数据
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}

/// 2.2.1 延展Encodable，用于字典、数组转换成模型
extension Encodable {
    
    public func encoder() ->Data? {
        let ecd = JSONEncoder()
        ecd.outputFormatting = .prettyPrinted
        return try? ecd.encode(self)
    }
}
/// 2.2.2 延展Data，用于字典、数组转换成模型
extension Data {
    
    /// Data -> Dictionary
    public func toDictionary() -> [String:Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? [String:Any]
    }
    
    /// Data -> String
    public func toString() ->String? {
        return String(data:self, encoding: .utf8)
    }

    /// Data -> JSON
    /// 未使用SwiftyJSON，请注释或删除以下方法
    public func toJSON() ->JSON? {
        return try? JSON(data:self)
    }
    
    /// Data -> Array
    public func toArrray() -> [Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? [Any]
    }
}
