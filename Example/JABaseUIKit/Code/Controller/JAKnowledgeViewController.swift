//
//  JAKnowledgeViewController.swift
//  JABaseUIKit_Example
//
//  Created by Qiyeyun7 on 2021/8/30.
//  Copyright © 2021 lanmemory@163.com. All rights reserved.
//

import UIKit
import JABaseUIKit
class JAKnowledgeViewController: QSCollectionViewController {
    
    var num:String = "15";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tf = UITextField();
        tf.placeholder = "请输入数字"
        tf.delegate = self
        view.addSubview(tf);
        tf.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(0)
            make.height.equalTo(45)
        }
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(tf.snp_bottom)
            make.left.right.bottom.equalTo(0)
        }
        let arr: [String] = ["位运算两值互换","取反",
                             "二进制 -> 八进制","二进制 -> 十进制","二进制 -> 十六进制",
                             "八进制 -> 二进制","八进制 -> 十进制","八进制 -> 十六进制",
                             "十进制 -> 二进制","十进制 -> 八进制","十进制 -> 十六进制",
                             "十六进制 -> 二进制","十六进制 -> 八进制","十六进制 -> 十进制"
        ]
        
        self.space = 5.0
        
        dataSource.addObjects(from: arr)
    }
}

extension JAKnowledgeViewController: UITextFieldDelegate{
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.num = textField.text ?? "15"
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension JAKnowledgeViewController{

    // cell点击事件响应
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = getData(indexPath: indexPath)
        guard !(value is NSNull) else {
            return
        }
        self.view.endEditing(true)
        testSwift(value: value)
    }
    
    private func testSwift(value: Any)->Void{
//        guard !(value is String || value is NSString) else {
//            return
//        }
        let str: String = value as! String
        
        switch str {

        case "位运算两值互换": do {
            let result = BitOperatedModel.exchangeValue(a: 15, b: 2)
            print("位运算输入返回结果：",result.first,result.second)
        }
        case "取反": do {
            guard let num = Int(self.num) else { return}
            print("原始值：\(num) 二进制：\(self.num.decimalToBinary())")
            print("取反值：\(~num) 二进制：\(String(~num).decimalToBinary())")
            print("参考：https://blog.csdn.net/Runner1st/article/details/86515884")
        }
        case "二进制 -> 八进制": do {self.num.binaryToOctal()}
        case "二进制 -> 十进制": do {self.num.binaryTodecimal()}
        case "二进制 -> 十六进制": do {self.num.binaryToHexadecimal()}
        
        case "八进制 -> 二进制": do {self.num.octalTobinary()}
        case "八进制 -> 十进制": do {self.num.octalTodecimal()}
        case "八进制 -> 十六进制": do {self.num.octalToHexadecimal()}
        
        case "十进制 -> 二进制": do {self.num.decimalToBinary()}
        case "十进制 -> 八进制": do {self.num.decimalToOctal()}
        case "十进制 -> 十六进制": do {self.num.decimalToHexadecimal()}
        case "十六进制 -> 二进制": do {self.num.hexadecimalToBinary()}
        case "十六进制 -> 八进制": do {self.num.hexadecimalToOctal()}
        case "十六进制 -> 十进制": do {self.num.hexadecimalToDecimal()}
        default: break
        }
    }
}
