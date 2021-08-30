//
//  BitOperatedModel.swift
//  JABaseUIKit_Example
//
//  Created by Qiyeyun7 on 2021/8/30.
//  Copyright © 2021 lanmemory@163.com. All rights reserved.
//

import Foundation

// 位运算model
class BitOperatedModel: NSObject {
    
    // MARK: ========= 不借助临时变量，交换2个变量的值
    static func exchangeValue(a: Int,b:Int) -> (first: Int,second: Int) {
        var a1 = a
        var b1 = b
        print("原始值：",a1,b1)
        a1 = a1 ^ b1
        print("第一次改a1的值：",a1)
        b1 = a1 ^ b1
        print("第一次改b1的值：",b1)
        a1 = a1 ^ b1;
        print("第二次改a1的值：",a1)
        return (a1, b1)
    }
    // MARK: ========= 无符号整数二进制中1的个数
    /**
       第一种解法：
       循环遍历无符号整数二进制的每一位判断是否为1。
       如果二进制中有较多的0，每次右移一位做出判断会很浪费
     */

    static func countOfOnes1(num: UInt) -> UInt {
        var count: UInt = 0
        var temp = num
        while temp != 0 {
            count += temp & 1
            temp = temp >> 1
        }
        return count
    }
    /**
       第二种解法：
       使用技巧num = num & (num - 1)消去二进制中最低位的1。
       如果最低位为1，num-1后相应位为0，相与之后为0；如果最低位为0，num-1向前借1，有1位则变为0，相与之后为0，则消去了最低位的1。
       统计消去次数，便是二进制1的个数
     */

    static func countOfOnes2(num: UInt) -> UInt {
        var count: UInt = 0
        var temp = num
        while (temp != 0) {
            count = count + 1
            temp = temp & (temp - 1)
        }
        return count
    }
    // MARK: ========= 引申：如何判断一个整数为2的整数次幂
    /**
       一个整数如果是2的整数次方，那么它的二进制表示中有且只有一位是1，而其他位都是0，如果使用num = num & (num - 1)消去最低位1后，num为0。即判断是否为0，即可判断是否为2的整数次幂。
     */
    static func isPowerOfTwo(num: UInt) -> Bool {
        return (num & (num - 1) == 0)
    }
    
    // MARK: =========  缺失的数字
    /**
       很多成对出现的正整数保存在磁盘文件中。注意成对的数字不一定是相邻的，如2、3、4、3、4、2...,由于意外一个数字消失了，如何快速找到是哪个数字消失了？
       技巧：
       0异或任何数为0，一个数异或自己为0
       解法：
       数组中的数成对出现，缺失一个数，将所有数异或起来便剩下缺失的数（其他所有成对的数异或为0）
     */
    static func findLostNum(nums: [UInt]) -> UInt {
        var lostNum: UInt = 0
        for num in nums {
            lostNum = lostNum ^ num
        }
        return lostNum
    }
    // MARK: =========  缺失的数字2
    // 如果有2个数字以外丢失（丢失的不是相等的数字），该如何找到丢失的2个数字？
    /**
     思路:设题目中这两个只出现1次的数字分别为A和B,如果能将A, B分开到二个数组
     中，那显然符合“异或”解法的关键点了。因此这个题目的关键点就是将A, B分开到二个数
     组中。由于A，B肯定是不相等的，因此在二进制上必定有- -位是不同的。根据这一位是0还
     是1可以将A和B分开到A组和B组。而这个数组中其它数字要么就属于A组，要么就属
     于B组。再对A组和B组分别执行“异或"解法就可以得到A,B了。而要判断A,B在哪
     一位上不相同，只要根据"A 异或B”的结果就可以知道了，这个结果在二进制上为1的位
     都说明A, B在这一-位.上是不相同的。
     */
    static func findTwoLostNum(nums: [UInt]) -> (UInt, UInt) {
        var lostNum1: UInt = 0
        var lostNum2: UInt = 0
        var temp: UInt = 0
        //两个缺失数的异或
        for num in nums {
            temp = temp ^ num
        }
        var flag: UInt = 1
        //将temp分为temp和flag的异或
        while ((temp & flag) == 0) {
            flag = flag << 1
        }
        //对nums进行分组
        for num in nums {
            if flag & num == 0 {
                lostNum1 = lostNum1 ^ num
            } else {
                lostNum2 = lostNum2 ^ num
            }
        }
        return (lostNum1, lostNum2)
    }
}

class HexCon: NSObject {
    // 十进制转二进制: String(15,radix:2)      返回为“1111”
    // 十进制转十六进制,返回的是字符串格式 String(15,radix:16)
    
    // 二进制转换成10进制
    static func binary2dec(num: String) -> Int {
        var sum = 0
        for c in num {
            sum = sum * 2 + Int("\(c)")!
        }
        return sum
    }

    // 十六进制转十进制
    static func changeToInt(num:String) -> Int {
        
        let str = num.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    //当然也可以不必扩展String，定义一个函数即可。
    static func hexadecimalToDecimal(num:String) -> Int {
        let str = num.uppercased
        var sum = 0
        for i in str().utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
//    static func hexadecimalToBinary(num: String) -> String {
//        // 十六进制
//        let hexadecimal = num
//        // 十进制
//        let decimal = hexadecimalToDecimal(num: num)
//        // 二进制
//        return decimal.decimalToBinary()
//    }
    
}

extension String {
    // MARK: 4.3、字符串转 Int
    /// 字符串转 Int
    /// - Returns: Int
    func toInt() -> Int? {
        if let num = NumberFormatter().number(from:self) {
            return num.intValue
        } else {
            print("\(self) 转换Int失败)")
            return nil
        }
    }
    
    // MARK: 1.1、二进制 -> 八进制
    /// 二进制 ->转 八进制
    /// - Returns: 八进制
    func binaryToOctal() -> String {
        // 二进制
        let binary = self
        // 十进制
        let decimal = binary.binaryTodecimal()
        // 八进制
        return decimal.decimalToOctal()
    }
    // MARK: 1.2、二进制 -> 十进制
    /// 二进制 -> 十进制
    /// - Returns: 十进制
    func binaryTodecimal() -> String {
        let binary = self
        var sum = 0
        for c in binary {
            if let number = "\(c)".toInt() {
                sum = sum * 2 + number
            }
        }
        print("\(self) 二进制转化十进制结果：\(sum)")
        return "\(sum)"
    }
    
    // MARK: 1.3、二进制 转 十六进制
    /// 二进制  ->  十六进制
    /// - Returns: 十六进制
    func binaryToHexadecimal() -> String {
        // 二进制
        let binary = self
        // 十进制
        let decimal = binary.binaryTodecimal()
        // 十六进制
        return decimal.decimalToHexadecimal()
    }
    
    // MARK: 1.4、八进制 -> 二进制
    /// 八进制 -> 二进制
    /// - Returns: 二进制
    func octalTobinary() -> String {
        // 八进制
        let octal = self
        // 十进制
        let decimal = octal.octalTodecimal()
        // 二进制
        return decimal.decimalToBinary()
    }
    
    // MARK: 1.5、八进制 -> 十进制
    /// 八进制 -> 十进制
    /// - Returns: 十进制
    func octalTodecimal() -> String {
        let binary = self
        var sum: Int = 0
        for c in binary {
            if let number = "\(c)".toInt() {
                sum = sum * 8 + number
            }
        }
        print("\(self) 八进制转化十进制结果：\(sum)")
        return "\(sum)"
    }
    
    // MARK: 1.6、八进制 -> 十六进制
    /// 八进制 -> 十六进制
    /// - Returns: 十六进制
    func octalToHexadecimal() -> String {
        // 八进制
        let octal = self
        // 十进制
        let decimal = octal.octalTodecimal()
        // 十六进制
        return decimal.decimalToHexadecimal()
    }
    
    // MARK: 1.7、十进制 -> 二进制
    /// 十进制 -> 二进制
    /// - Returns: 二进制
    func decimalToBinary() -> String {
        guard var decimal = self.toInt() else {
            return ""
        }
        var str = ""
        while decimal > 0 {
            str = "\(decimal % 2)" + str
            decimal /= 2
        }
        print("\(self) 十进制 -> 二进制：\(str)")
        return str
    }
    
    // MARK: 1.8、十进制 -> 八进制
    /// 十进制 -> 八进制
    /// - Returns: 八进制
    func decimalToOctal() -> String {
        guard let decimal = self.toInt() else {
            return ""
        }
        /*
         等价代码
         guard var decimal = self.toInt() else {
         return ""
         }
         var str = ""
         while decimal > 0 {
         str = "\(decimal % 8)" + str
         decimal /= 8
         }
         return str
         */
        let str = String(format: "%0O", decimal)
        print("\(self) 十进制 -> 八进制：\(str)")
        return str
    }
    // MARK: 1.9、十进制 -> 十六进制
    /// 十进制 -> 十六进制
    /// - Returns: 十六进制
    func decimalToHexadecimal() -> String {
        guard let decimal = self.toInt() else {
            return ""
        }
        /*
         等价代码
         guard var decimal = self.toInt() else {
         return ""
         }
         var str = ""
         while decimal > 0 {
         str = "\(decimal % 16)" + str
         decimal /= 16
         }
         return str
         */
        //小写”x“，大写”X“
        let str = String(format: "%0x", decimal)
        print("\(self) 十进制 -> 十六进制：\(str)")
        return str
    }
    
    // MARK: 1.10、十六进制 -> 二进制
    /// 十六进制  -> 二进制
    /// - Returns: 二进制
    func hexadecimalToBinary() -> String {
        // 十六进制
        let hexadecimal = self
        // 十进制
        let decimal = hexadecimal.hexadecimalToDecimal()
        // 二进制
        return decimal.decimalToBinary()
    }
    
    // MARK: 1.11、十六进制 -> 八进制
    /// 十六进制  -> 八进制
    /// - Returns: 八进制
    func hexadecimalToOctal() -> String {
        // 十六进制
        let hexadecimal = self
        // 十进制
        let decimal = hexadecimal.hexadecimalToDecimal()
        // 八进制
        return decimal.decimalToOctal()
    }
    
    // MARK: 1.12、十六进制 -> 十进制
    /// 十六进制  -> 十进制
    /// - Returns: 十进制
    func hexadecimalToDecimal() -> String {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            // 0-9 从48开始
            sum = sum * 16 + Int(i) - 48
            // A-Z 从65开始，但有初始值10，所以应该是减去55
            if i >= 65 {
                sum -= 7
            }
        }
        print("\(self) 十六进制 -> 十进制：\(sum)")
        return "\(sum)"
    }
}
