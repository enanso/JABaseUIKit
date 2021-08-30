//
//  NSString+QSCategory.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/30.
//

import Foundation

/*!
 进制之间相互转换
 1.0 字符串转 Int
 1.1、二进制 -> 八进制:    self.binaryToOctal()
 1.2、二进制 -> 十进制:    self.binaryTodecimal()
 1.3、二进制 -> 十六进制:   self.binaryToHexadecimal()
 1.4、八进制 -> 二进制:    self.octalTobinary()
 1.5、八进制 -> 十进制:    self.octalTodecimal()
 1.6、八进制 -> 十六进制:   self.octalToHexadecimal()
 1.7、十进制 -> 二进制:     self.decimalToBinary()
 1.8、十进制 -> 八进制:     self.decimalToOctal()
 1.9、十进制 -> 十六进制:   self.decimalToHexadecimal()
 1.10、十六进制 -> 二进制:  self.hexadecimalToBinary()
 1.11、十六进制 -> 八进制:  self.hexadecimalToOctal()
 1.12、十六进制 -> 十进制:  self.hexadecimalToDecimal()
 */


//extension String {
//    // MARK: 4.3、字符串转 Int
//    /// 字符串转 Int
//    /// - Returns: Int
//    func toInt() -> Int? {
//        if let num = NumberFormatter().number(from:self) {
//            return num.intValue
//        } else {
//            print("\(self) 转换Int失败)")
//            return nil
//        }
//    }
//    
//    // MARK: 1.1、二进制 -> 八进制
//    /// 二进制 ->转 八进制
//    /// - Returns: 八进制
//    func binaryToOctal() -> String {
//        // 二进制
//        let binary = self
//        // 十进制
//        let decimal = binary.binaryTodecimal()
//        // 八进制
//        return decimal.decimalToOctal()
//    }
//    // MARK: 1.2、二进制 -> 十进制
//    /// 二进制 -> 十进制
//    /// - Returns: 十进制
//    func binaryTodecimal() -> String {
//        let binary = self
//        var sum = 0
//        for c in binary {
//            if let number = "\(c)".toInt() {
//                sum = sum * 2 + number
//            }
//        }
//        print("\(self) 二进制转化十进制结果：\(sum)")
//        return "\(sum)"
//    }
//    
//    // MARK: 1.3、二进制 -> 十六进制
//    /// 二进制  ->  十六进制
//    /// - Returns: 十六进制
//    func binaryToHexadecimal() -> String {
//        // 二进制
//        let binary = self
//        // 十进制
//        let decimal = binary.binaryTodecimal()
//        // 十六进制
//        return decimal.decimalToHexadecimal()
//    }
//    
//    // MARK: 1.4、八进制 -> 二进制
//    /// 八进制 -> 二进制
//    /// - Returns: 二进制
//    func octalTobinary() -> String {
//        // 八进制
//        let octal = self
//        // 十进制
//        let decimal = octal.octalTodecimal()
//        // 二进制
//        return decimal.decimalToBinary()
//    }
//    
//    // MARK: 1.5、八进制 -> 十进制
//    /// 八进制 -> 十进制
//    /// - Returns: 十进制
//    func octalTodecimal() -> String {
//        let binary = self
//        var sum: Int = 0
//        for c in binary {
//            if let number = "\(c)".toInt() {
//                sum = sum * 8 + number
//            }
//        }
//        print("\(self) 八进制转化十进制结果：\(sum)")
//        return "\(sum)"
//    }
//    
//    // MARK: 1.6、八进制 -> 十六进制
//    /// 八进制 -> 十六进制
//    /// - Returns: 十六进制
//    func octalToHexadecimal() -> String {
//        // 八进制
//        let octal = self
//        // 十进制
//        let decimal = octal.octalTodecimal()
//        // 十六进制
//        return decimal.decimalToHexadecimal()
//    }
//    
//    // MARK: 1.7、十进制 -> 二进制
//    /// 十进制 -> 二进制
//    /// - Returns: 二进制
//    func decimalToBinary() -> String {
//        guard var decimal = self.toInt() else {
//            return ""
//        }
//        var str = ""
//        while decimal > 0 {
//            str = "\(decimal % 2)" + str
//            decimal /= 2
//        }
//        print("\(self) 十进制 -> 二进制：\(str)")
//        return str
//    }
//    
//    // MARK: 1.8、十进制 -> 八进制
//    /// 十进制 -> 八进制
//    /// - Returns: 八进制
//    func decimalToOctal() -> String {
//        guard let decimal = self.toInt() else {
//            return ""
//        }
//        /*
//         guard var decimal = self.toInt() else {
//         return ""
//         }
//         var str = ""
//         while decimal > 0 {
//         str = "\(decimal % 8)" + str
//         decimal /= 8
//         }
//         return str
//         */
//        let str = String(format: "%0O", decimal)
//        print("\(self) 十进制 -> 八进制：\(str)")
//        return str
//    }
//    // MARK: 1.9、十进制 -> 十六进制
//    /// 十进制 -> 十六进制
//    /// - Returns: 十六进制
//    func decimalToHexadecimal() -> String {
//        guard let decimal = self.toInt() else {
//            return ""
//        }
//        //小写”x“，大写”X“
//        let str = String(format: "%0x", decimal)
//        print("\(self) 十进制 -> 十六进制：\(str)")
//        return str
//    }
//    
//    // MARK: 1.10、十六进制 -> 二进制
//    /// 十六进制  -> 二进制
//    /// - Returns: 二进制
//    func hexadecimalToBinary() -> String {
//        // 十六进制
//        let hexadecimal = self
//        // 十进制
//        let decimal = hexadecimal.hexadecimalToDecimal()
//        // 二进制
//        return decimal.decimalToBinary()
//    }
//    
//    // MARK: 1.11、十六进制 -> 八进制
//    /// 十六进制  -> 八进制
//    /// - Returns: 八进制
//    func hexadecimalToOctal() -> String {
//        // 十六进制
//        let hexadecimal = self
//        // 十进制
//        let decimal = hexadecimal.hexadecimalToDecimal()
//        // 八进制
//        return decimal.decimalToOctal()
//    }
//    
//    // MARK: 1.12、十六进制 -> 十进制
//    /// 十六进制  -> 十进制
//    /// - Returns: 十进制
//    func hexadecimalToDecimal() -> String {
//        let str = self.uppercased()
//        var sum = 0
//        for i in str.utf8 {
//            // 0-9 从48开始
//            sum = sum * 16 + Int(i) - 48
//            // A-Z 从65开始，但有初始值10，所以应该是减去55
//            if i >= 65 {
//                sum -= 7
//            }
//        }
//        print("\(self) 十六进制 -> 十进制：\(sum)")
//        return "\(sum)"
//    }
//}
