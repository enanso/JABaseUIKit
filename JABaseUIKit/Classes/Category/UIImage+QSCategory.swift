//
//  UIImage+QSCategory.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/16.
//

import Foundation

extension UIImage {
    
    /**图片缩放到指定大小尺寸**/
    func scaleToSize(w:CGFloat,h:CGFloat)->UIImage{
        
        // 创建一个bitmap的context,并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSize(width: w, height: h));
        // 绘制改变大小的图片
        self.draw(in: CGRect(x: 0, y: 0, width:w, height:h))
        
        // 从当前context中创建一个改变大小后的图片
        let scaledImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //使当前的context出堆栈
        UIGraphicsEndImageContext();
        
        // 返回新的改变大小后的图片
        return scaledImage;
    }
    
    /**改变图片颜色**/
    func changeWithColor(color:UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let context = UIGraphicsGetCurrentContext();
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        //使当前的context出堆栈
        UIGraphicsEndImageContext();
        return  newImage!
    }
    
    /**用颜色创建一张图片**/
    static func imageWithColor(color:UIColor,rect:CGRect) -> UIImage{
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
}
