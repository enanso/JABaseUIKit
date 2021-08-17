//
//  UIView+QSCategory.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/16.
//

import Foundation

extension UIView {

    //读取x坐标
    var x:CGFloat{
        return self.frame.origin.x
    }
    
    //读取y坐标
    var y:CGFloat {
        return self.frame.origin.y
    }
    
    //读取中心点x坐标
    var c_x:CGFloat {
        return self.center.x
    }
    
    //读取中心点y坐标
    var c_y:CGFloat {
        return self.center.y
    }
    
    //读取宽度w
    var w:CGFloat {
        return self.frame.size.width
    }
    
    //读取高度h
    var h:CGFloat {
        return self.frame.size.height
    }
    
    //读取右侧距离x坐标的位置
    var r:CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    //读取底部距离y坐标的位置
    var b:CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
}
