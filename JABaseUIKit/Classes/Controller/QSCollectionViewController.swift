//
//  QSCollectionViewController.swift
//  JABaseUIKit
//
//  Created by JABase on 2021/8/20.
//

import UIKit
import SnapKit
let cellMIdentifier = "cellMIdentifierId"
open class QSCollectionViewController: QSViewController {
    
    //自定义collectionView单行item个数，默认：1
    private var count:Int = 1
    //自定义collectionView单行item高度，默认：80.0
    private var height:CGFloat = 80.0
    //item之间的默认间距
    @objc open var space:CGFloat = 0.0
    
    // MARK: Public
    @objc public init(count: Int, height: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.count = count > 0 ? count:1
        self.height = height > 0 ? height:80.0
    }
    // tableView 初始化
    @objc public lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical//设置垂直显示

        let collectionView = UICollectionView(frame: CGRect(x: 0, y:0, width: kWidth, height: kHeight), collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.white

        collectionView.register(QSBaseCollectionViewCell.self, forCellWithReuseIdentifier: cellMIdentifier)
        collectionView.dataSource = self

        collectionView.delegate = self
        self.view.addSubview(collectionView)
        return collectionView
    }()
    // 数据源数组，可存一维数组或者二维数组
    @objc public lazy var dataSource:NSMutableArray = {
        let data = NSMutableArray()
        return data
    }()
    
    // 分区头部数据，以每个分区所在的数据数组的指针地址作为key
    @objc public lazy var headDict:NSMutableDictionary = {
        let dict = NSMutableDictionary()
        return dict
    }()
    
    // 分区尾部数据，以每个分区所在的数据数组的指针地址作为key
    @objc public lazy var footerDict:NSMutableDictionary = {
        let dict = NSMutableDictionary()
        return dict
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //布局UI
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0);
        }
    }
    
    // 读取数据
    public func getData(indexPath: IndexPath)->Any{
        if iS2DArray() {
            guard dataSource.count > indexPath.section   else {
                print("一维数组取值越界了")
                return NSNull()
            }
            //未越界继续取值
            let array:NSArray = dataSource[indexPath.section] as! NSArray
            guard array.count > indexPath.row   else {
                print("二维数组取值越界了")
                return NSNull()
            }
            //未越界返回结果
            return array[indexPath.row]
        }else {
            guard dataSource.count > indexPath.row   else {
                print("一维数组取值越界了")
                return NSNull()
            }
            //未越界返回结果
            return dataSource[indexPath.row]
        }
    }
    
    // MARK: Private
    private init(){
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = kRandomColor()
    }
    //必须实现
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    // 判断是否为二维数组
    private func iS2DArray()->Bool {
        let firstObject = dataSource.firstObject
        if firstObject is NSArray {
            return true
        }
        return false
    }
    
    // 读取分区头部视图存储数据对象
    private func sectionObject(section: Int, isFooter: Bool)->Any {
        
        // 读取指针首地址
        let key = self.fooString(object:dataSource[section])
        // 通过指针首地址取出对象
        let obj:Any?
        if isFooter {
            obj = self.footerDict.object(forKey: key)
        }else {
            obj = self.headDict.object(forKey: key)
        }
        guard (obj != nil) else {
            return NSNull()
        }
        return obj as Any;
    }

}
// MARK: ============== UICollectionViewDelegateFlowLayout 实现 ==============
extension QSCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    //单个Item大小: layout.itemSize = CGSize(width: width, height: height)
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = (kWidth - space * CGFloat((count + 1))) / CGFloat(count)
        return CGSize(width: width, height: height)
    }
    
    //设置边距: layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space, bottom: 0, right: space)
    }
    
    //每个相邻的layout的上下间隔: layout.minimumLineSpacing = 0.0
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return space
    }
    //每个相邻layout的左右间隔: layout.minimumInteritemSpacing = 0.0
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return space
    }
    //分区头部size设置
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 0.0)
    }
    //分区尾部部size设置
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: kWidth, height: 0.0)
    }
}
// MARK: ============== UICollectionViewDataSource 实现 ==============
extension QSCollectionViewController: UICollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if iS2DArray() {
            guard dataSource.count > section   else {
                return 0
            }
            let array:NSArray = dataSource[section] as! NSArray
            return array.count
        }
        return dataSource.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:QSBaseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMIdentifier, for: indexPath as IndexPath) as! QSBaseCollectionViewCell
        let textColor = kRandomColor()
        if textColor != .white {
            cell.label.textColor = textColor;
        }else {
            cell.label.textColor = .red;
        }
        let title = getData(indexPath: indexPath)
        guard !(title is NSNull) else {
            cell.label.text = ""
            return cell
        }
        cell.label.text = title as? String
        return cell
    }
    open func numberOfSections(in collectionView: UICollectionView) -> Int{
        if iS2DArray() {
            return dataSource.count
        }
        return 1
    }
}

// MARK: ============== UICollectionViewDelegate 实现 ==============
extension QSCollectionViewController: UICollectionViewDelegate {
    
    // cell点击事件响应
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("======我在里面响应了======")
    }
 
}
