//
//  QSBaseCollectionViewCell.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/20.
//

import UIKit
import SnapKit

class QSBaseCollectionViewCell: UICollectionViewCell {
    
    // TODO: *** 懒加载子控件 ***
    //标题
    public lazy var label:UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "PingFang", size: 2)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // 图片
    public lazy var imgView:UIImageView = {
        
        let image = Bundle.image(name: "placeholder@2x").scaleToSize(w: 35, h: 35)
        let imageView = UIImageView(image: image)
        //设置图片显示方式
        imageView.contentMode = .scaleAspectFill
        //设置图片超出容器的部分不显示
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /*!
     // convenience 便利构造器
     convenience required public init?(coder aDecoder: NSCoder) {
         self.init(coder: aDecoder)
         fatalError("init(coder:) has not been implemented")
     }
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //重写初始化
    override  init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    // 构建UI
    private func setUI(){
        contentView.addSubview(label)
        contentView.addSubview(imgView)

        imgView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(5)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(label.snp_top).offset(-3)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp_centerY).offset(5)
            make.left.equalTo(3)
            make.right.equalTo(-3)
            make.bottom.lessThanOrEqualTo(0)
        }
    }
}
