//
//  ZPLeftView.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/15.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

@objc protocol ZPLeftViewDelegate :NSObjectProtocol {
    @objc func selectLeftIndex(index:Int)
}

class ZPLeftView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    weak var delegate:ZPLeftViewDelegate?
    var leftTableView:UITableView?
    var lineView:UIView?
    var dataList:NSMutableArray = []
    let titleList :[String] = ["蔬","菜","水","果","鲜","花","大","米","饭","运","筹","帷","幄","掌","握","提","案","评","议","米"]
    var selectIndex:Int = 0
    var dataDic:Dictionary<String, NSObject> = [:]
    var cellRect:CGRect?
    var oldSelectIndex:Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 1..<20{
            let str = titleList[i]
            let titileStr = "果蔬"+str+"家"
            if i == 1 {
                dataDic = ["title":String(titileStr), "select":Bool(true)] as! Dictionary<String, NSObject>
            }else{
                dataDic = ["title":String(titileStr), "select":Bool(false)] as! Dictionary<String, NSObject>
            }
            dataList.add(dataDic)
        }
        
        lineView = UIView.init(frame: CGRect(x: self.frame.size.width - 1, y: 0, width: 1, height: self.frame.size.height))
        lineView?.backgroundColor = UIColor.yellow
        self.addSubview(lineView!)
        
        leftTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width-1, height: self.frame.size.height), style: UITableViewStyle.plain)
        leftTableView?.delegate = self
        leftTableView?.dataSource = self
        leftTableView?.showsVerticalScrollIndicator = false;
        leftTableView?.register(UINib.init(nibName: "ZPLeftTableViewCell", bundle: nil), forCellReuseIdentifier: "ZPLeftTableViewCell")
        self.addSubview(leftTableView!)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZPLeftTableViewCell", for: indexPath) as!ZPLeftTableViewCell
        cell.selectionStyle = .none
        let dic:Dictionary = dataList[indexPath.row] as! Dictionary<String, NSObject>
        cell.titleLabel.text = dic["title"] as? String
        if dic["select"] as? Bool == true {
            cell.leftView.backgroundColor = UIColor.red
        }else{
            cell.leftView.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        oldSelectIndex = selectIndex
        selectIndex = indexPath.row
        self.modifyDataTheArray()
        if selectIndex != oldSelectIndex {
            let oldIndexPath:NSIndexPath = NSIndexPath.init(row: oldSelectIndex, section: 0)
            let oldCGRect = leftTableView?.rectForRow(at: oldIndexPath as IndexPath)
            if (oldCGRect?.origin.y)! + 60 - (leftTableView?.contentOffset.y)! > 0 && (oldCGRect?.origin.y)! - (leftTableView?.contentOffset.y)! < (leftTableView?.frame.size.height)! {
                let cell : ZPLeftTableViewCell = leftTableView?.cellForRow(at: NSIndexPath.init(row: oldSelectIndex, section: 0) as IndexPath) as! ZPLeftTableViewCell
                cell.leftView.backgroundColor = UIColor.white
            }
            let cell : ZPLeftTableViewCell = leftTableView?.cellForRow(at: NSIndexPath.init(row: selectIndex, section: 0) as IndexPath) as! ZPLeftTableViewCell
            cell.leftView.backgroundColor = UIColor.red
        }
        self.leftTableView?.scrollToRow(at: NSIndexPath.init(row: selectIndex, section: 0) as IndexPath, at: UITableViewScrollPosition.middle, animated: true)
        
        if delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.selectLeftIndex(index:))))!{
            delegate?.selectLeftIndex(index: selectIndex)
        }
    }
    
    
    public func selectLeftIndex(index:Int){
        selectIndex = index
        self.modifyDataTheArray()
        // old 选中的cell
        if oldSelectIndex >= 0{
            let oldIndexPath:NSIndexPath = NSIndexPath.init(row: oldSelectIndex, section: 0)
            let oldCGRect = leftTableView?.rectForRow(at: oldIndexPath as IndexPath)
            if (oldCGRect?.origin.y)! + 60 - (leftTableView?.contentOffset.y)! > 0 && (oldCGRect?.origin.y)! - (leftTableView?.contentOffset.y)! < (leftTableView?.frame.size.height)! {
                let cell : ZPLeftTableViewCell = leftTableView?.cellForRow(at: NSIndexPath.init(row: oldSelectIndex, section: 0) as IndexPath) as! ZPLeftTableViewCell
                cell.leftView.backgroundColor = UIColor.white
            }
        }
        
        // 当前选中的cell
        let currentIndexPath:NSIndexPath = NSIndexPath.init(row: selectIndex, section: 0)
        let currentCGRect = leftTableView?.rectForRow(at: currentIndexPath as IndexPath)
        if (currentCGRect?.origin.y)! + 60 - (leftTableView?.contentOffset.y)! > 0 && (currentCGRect?.origin.y)! - (leftTableView?.contentOffset.y)! < (leftTableView?.frame.size.height)! {
            let cell : ZPLeftTableViewCell = leftTableView?.cellForRow(at: NSIndexPath.init(row: selectIndex, section: 0) as IndexPath) as! ZPLeftTableViewCell
            cell.leftView.backgroundColor = UIColor.red
        }
    
        self.leftTableView?.scrollToRow(at: NSIndexPath.init(row: selectIndex, section: 0) as IndexPath, at: UITableViewScrollPosition.middle, animated: true)
        
    }
    
    // 修改数组中的数据
    func modifyDataTheArray(){
        for i in 0..<self.dataList.count {
            var dic : Dictionary = dataList[i] as! Dictionary<String, NSObject>
            if dic["select"] as? Bool == true {
                if i != selectIndex {
                    oldSelectIndex = i
                    let str = dic["title"] as? String
                    let dic2:Dictionary<String, NSObject> = ["title":str! as NSObject, "select":Bool(false) as NSObject]
                    dataList.replaceObject(at: i, with: dic2)
                    var dic1 : Dictionary = dataList[selectIndex] as! Dictionary<String, NSObject>
                    let str1 = dic1["title"] as? String
                    let dic3:Dictionary<String, NSObject> = ["title":str1! as NSObject, "select":Bool(true) as NSObject]
                    dataList.replaceObject(at: selectIndex, with: dic3)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
