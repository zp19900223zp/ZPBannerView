//
//  ZPScrollView.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/26.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ZPScrollView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    let kWidth = UIScreen.main.bounds.size.width
    let kHeight = UIScreen.main.bounds.size.height
    var collectionView:UICollectionView?
    var selectIndex:Int = 0
    var lineWidth:CGFloat = 0
    var linePoint:CGPoint?
    
    let dataArray:Array<String> = ["读书","写字","看电视","玩游戏","侏罗纪公园","上山","下海","旅游","供桌","工作","图表","数组","字典","字符串"]
    
    var lineView:UIView?
    
    var statusArray:NSMutableArray = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ZPCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZPCollectionViewCell", for: indexPath) as! ZPCollectionViewCell
        cell.titleLabel.text = dataArray[indexPath.row]
        let dic:Dictionary<String,String> = statusArray[indexPath.item] as! Dictionary<String, String>
        let str:String = dic["status"]!
//        if str == "1" {
//            cell.titleLabel.font = UIFont.systemFont(ofSize: 16)
//            cell.titleLabel.textColor = UIColor.red
//        }else{
//            cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
//            cell.titleLabel.textColor = UIColor.black
//        }
        return cell
    }
    
    // 移动的位置
    public func locationOfMobile(location:CGFloat){
        let gap:CGFloat = location - CGFloat(selectIndex) * kWidth
        let gapRatio = gap / kWidth
        print(gapRatio)
        if gap > 0 {
            if selectIndex == dataArray.count - 1 {
                return
            }
            var rightPoint:CGPoint = linePoint!
            let widthX = (linePoint?.x)! + gapRatio * 80
            rightPoint.x = widthX
            lineView?.center = rightPoint
            
            let strO:String = dataArray[selectIndex]
            let widthSO = calculateRowWidth(string: strO)
            let str:String = dataArray[selectIndex + 1]
            let widthS = calculateRowWidth(string: str)
            let difference = widthSO - widthS
            var rightFrame:CGRect = (lineView?.frame)!
            rightFrame.size.width = widthSO - difference * gapRatio
            lineView?.frame = rightFrame
        }else{
            if selectIndex == 0 {
                return
            }
            var rightPoint:CGPoint = linePoint!
            let widthX = (linePoint?.x)! + gapRatio * 80
            rightPoint.x = widthX
            lineView?.center = rightPoint
           
            let strO:String = dataArray[selectIndex]
            let widthSO = calculateRowWidth(string: strO)
            let str:String = dataArray[selectIndex - 1]
            let widthS = calculateRowWidth(string: str)
            let difference = widthSO - widthS
            var rightFrame:CGRect = (lineView?.frame)!
            rightFrame.size.width = widthSO + difference * gapRatio
            lineView?.frame = rightFrame
        }
//        dealWithColorChange(changeRate: gapRatio)
    }
    
    // 结束滑动
    public func endScrollView(location:CGFloat){
        selectIndex =  Int(location / kWidth)
        let indexPath:IndexPath = IndexPath.init(row: selectIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        collectionView?.layoutIfNeeded()
        lineWidth = (lineView?.frame.origin.x)!
        linePoint = lineView?.center
    }
    
    // 处理变化的颜色
    func  dealWithColorChange(changeRate:CGFloat)  {
        if changeRate > 0  {
            let indexPath:IndexPath = IndexPath.init(row: selectIndex, section: 0)
            let cell:ZPCollectionViewCell = collectionView?.cellForItem(at: indexPath) as! ZPCollectionViewCell
            let indexPath1:IndexPath = IndexPath.init(row: selectIndex+1, section: 0)
            let cell1:ZPCollectionViewCell = collectionView?.cellForItem(at: indexPath1) as! ZPCollectionViewCell
            let font:UIFont = UIFont.systemFont(ofSize: 16-changeRate*2)
            let font1:UIFont = UIFont.systemFont(ofSize: 14+changeRate*2)
            cell.titleLabel.font = font
            cell1.titleLabel.font = font1
        }else {
            let indexPath:IndexPath = IndexPath.init(row: selectIndex, section: 0)
            let cell:ZPCollectionViewCell = collectionView?.cellForItem(at: indexPath) as! ZPCollectionViewCell
            let indexPath1:IndexPath = IndexPath.init(row: selectIndex-1, section: 0)
            let cell1:ZPCollectionViewCell = collectionView?.cellForItem(at: indexPath1) as! ZPCollectionViewCell
            let font:UIFont = UIFont.systemFont(ofSize: 16+changeRate*2)
            let font1:UIFont = UIFont.systemFont(ofSize: 14-changeRate*2)
            cell.titleLabel.font = font
            cell1.titleLabel.font = font1
        }
        
    }
    
    func setUI() {
        for i in 0..<dataArray.count {
            if i == 0 {
                let dic:Dictionary<String,String> = ["status":"1"]
                statusArray.add(dic)
            }else{
                let dic:Dictionary<String,String> = ["status":"0"]
                statusArray.add(dic)
            }
        }
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 80, height: self.frame.size.height) // 设置cell的大小
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal // 设置布局方向
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0) // 设置每个cell的间距
        layout.minimumLineSpacing = 0.0 //  行间距
//        layout.minimumInteritemSpacing = 0.0 // 列间距
    
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UINib.init(nibName: "ZPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ZPCollectionViewCell")
        self.addSubview(collectionView!)
        
        let str:String = dataArray.first!
        let widthS = calculateRowWidth(string: str)
        lineView = UIView.init(frame: CGRect(x: 40 - widthS / 2, y: self.frame.size.height - 2, width: widthS, height: 2))
        lineView?.backgroundColor = UIColor.red
        collectionView?.addSubview(lineView!)
        lineWidth = (lineView?.frame.origin.x)!
        linePoint = lineView?.center
    }
    
    // 根据内容计算宽度
    func calculateRowWidth(string:String) -> CGFloat {
        return getNormalStrSize(str: string, font: 14, w: CGFloat.greatestFiniteMagnitude, h: 60).width
    }
    
    /**获取字符串尺寸--私有方法*/
    private func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)], context: nil).size
            return strSize
        }
        if attriStr != nil {
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        return CGSize.zero
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
