//
//  QSTableViewController.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/19.
// swift版 -- 基础tableView控制器

import UIKit
import SnapKit

open class QSTableViewController: QSViewController {

    // MARK: Public
    @objc public init(style : UITableView.Style) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
    }
    // tableView 初始化
    @objc public lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style:style)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.dark(light: "ffffff", dark: "1e1e1e")
        if #available(iOS 11.0, *) {//*** iOS 11 后的展示 ***
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(table)
        return table
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //布局UI
        tableView.snp.makeConstraints { (make) in
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
    //自定义tableView样式，默认：UITableView.Style.plain
    private var style:UITableView.Style = UITableView.Style.plain
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

// MARK: ============== UITableViewDataSource 实现 ==============
extension QSTableViewController: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        if iS2DArray() {
            return dataSource.count
        }
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if iS2DArray() {
            guard dataSource.count > section   else {
                return 0
            }
            let array:NSArray = dataSource[section] as! NSArray
            return array.count
        }
        return dataSource.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "testCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellid)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            let imageNext = UIImageView()
            imageNext.image = UIImage(named:"st_next@2x")
            cell?.detailTextLabel?.addSubview(imageNext)
            imageNext.backgroundColor = UIColor.white
            imageNext.snp.makeConstraints{(make) in
                make.right.bottom.top.equalTo(0);
                make.width.equalTo(imageNext.snp.height)
            }
            cell?.imageView?.image = UIImage(named:"placeholder")
            //2、调整大小
            let itemSize = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            
            let imageRect = CGRect(x: 0.0, y: 0.0, width: itemSize.width, height: itemSize.height)
            cell?.imageView?.image?.draw(in: imageRect)
            cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let line = UILabel()
            cell?.contentView.addSubview(line)
            line.backgroundColor = UIColor.lightGray
            line.snp.makeConstraints{(make) in
                make.left.right.bottom.equalTo(0);
                make.height.equalTo(0.5)
            }
        }

        cell?.detailTextLabel?.text = "      ."
        let title = getData(indexPath: indexPath)
        guard !(title is NSNull) else {
            cell?.textLabel?.text = ""
            return cell!
        }
        cell?.textLabel?.text = title as? String
        return cell!
    }
}

// MARK: ============== UITableViewDelegate 实现 ==============
extension QSTableViewController: UITableViewDelegate {
 
    
    // cell返回高度设置
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let obj = sectionObject(section: section, isFooter: false)
        guard !(obj is NSNull) else {
            return 0.00
        }
        return 30.00;
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let view = UIView();
        let obj = sectionObject(section: section, isFooter: false)
        guard (obj is NSDictionary) else {
            return view
        }
        view.frame = CGRect(x: 0, y: 0, width:tableView.frame.width, height: 30);
        view.backgroundColor = UIColor.red
        let title = (obj as! NSDictionary).object(forKey: "title")
        guard (title is NSString) else {
            return view
        }
        return view
    }
    
    // cell点击事件响应
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(getData(indexPath: indexPath))
    }
 
}
