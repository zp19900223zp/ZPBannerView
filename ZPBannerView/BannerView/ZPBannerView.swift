//
//  ZPBannerView.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/14.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit
import SDWebImage

let mainW = UIScreen.main.bounds.width
let mainH = UIScreen.main.bounds.height

var navH : CGFloat {
    get {
        if mainH == 812 {
            return 88
        }else{
            return 64
        }
    }
}

@objc protocol ZPBannerViewDelegate : NSObjectProtocol{
    @objc func clickBanner(index:Int)
}

class ZPBannerView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    var infiniteLoop : Bool = true // 循环滚动
    var autoScroll : Bool = true // 自动滚动
    var scrollInterval : Double = 3
    var selectImage:UIImage?
    var unselectImage:UIImage?
    weak var delegate:ZPBannerViewDelegate?
    
    private lazy var topImage : UIImageView = {
        let topImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height - 30))
        topImage.contentMode = .scaleAspectFill
        return topImage
    }()
    
    private lazy var bottomImage : UIImageView = {
       let bottomImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height - 30))
        bottomImage.contentMode = .scaleAspectFill
        return bottomImage
    }()
    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.width, height: self.height - navH - 10)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    private lazy var banner:UICollectionView = {
        let banner = UICollectionView.init(frame: CGRect(x: 0, y: navH+10, width: self.width, height: self.height - navH - 10), collectionViewLayout: flowLayout)
        banner.backgroundColor = UIColor.clear
        banner.isPagingEnabled = true
        banner.showsHorizontalScrollIndicator = false
        banner.delegate = self
        banner.dataSource = self
        self.addSubview(banner)
        self.bringSubview(toFront: banner)
        return banner
    }()
    
    private lazy var pageControl : SMPageControl = {
        let pageControl = SMPageControl()
        pageControl.isUserInteractionEnabled = true
        pageControl.frame = CGRect(x: mainW / 2 - 60, y: self.y + self.height - 25, width: 120, height: 6)
        self.addSubview(pageControl)
        return pageControl
    }()
    
    private lazy var leftView : ZPMaskView = {
        let leftView = ZPMaskView.init(frame: CGRect(x: -10, y: 0, width: self.width+10, height: self.height - 30))
        return leftView
    }()
    
    private lazy var rightView : ZPMaskView = {
        let rightView = ZPMaskView.init(frame: CGRect(x: 0, y: 0, width: self.width + 10, height: self.height + 30))
        return rightView
    }()
    
    private lazy var bannerMaskView : UIView = {
       let bannerMaskView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        return bannerMaskView
    }()
    
    private var timers:Timer? // 时间
    private var banners:[ZPBannerModel]! // 循环图片的数组
    private var lastContentOffset:CGFloat = 0
    
    private var  totalItemCount:Int = 0
    
    private var draggingIndex:Int = 0 // 拖动时的索引
    
    private var autoScrollIndex:Int = 0 // 自动滚动时的索引
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
    func adjustWhenControllerViewWillAppera()  {
        let targetIndex = self.currentIndex()
        if targetIndex < self.totalItemCount {
            print(targetIndex)
            print(totalItemCount)
            self.banner.scrollToItem(at: IndexPath.init(item: targetIndex, section: 0), at: [], animated: false)
            let itemIndex = self.pageControlIndexWithCurrentCellIndex(index: targetIndex)
            print(itemIndex)
            let topIndex = itemIndex + 1 > self.banners.count - 1 ? 0 : itemIndex + 1
            let bottomIndex = itemIndex
            self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
            self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.leftView.setRaidus(raidus: 0, direction: .right)
                self.rightView.setRaidus(raidus: 0, direction: .left)
            })
        }
        
    }
    
    func setUI() {
        self.addSubview(self.bottomImage)
        self.addSubview(self.topImage)
        self.topImage.mask = bannerMaskView
        bannerMaskView.addSubview(rightView)
        bannerMaskView.addSubview(leftView)
        
        self.banner.register(UINib.init(nibName: "ZPBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ZPBannerCollectionViewCell")
        
    }
    
    func setBanner(banners:[ZPBannerModel]){
        if banners.count > 1{
            self.totalItemCount = self.infiniteLoop ? banners.count * 200 : banners.count
            self.banners = banners
            self.banner.reloadData()
            self.banner.scrollToItem(at: IndexPath.init(row: totalItemCount/2, section: 0), at: [], animated: false)
            
            let index = self.pageControlIndexWithCurrentCellIndex(index: self.currentIndex())
            
            self.pageControl.numberOfPages = banners.count
            self.pageControl.currentPage = index
            self.setPageControlImage()
            
            if index + 1 > banners.count - 1{
                self.bottomImage.sd_setImage(with: URL.init(string: banners[0].bgImg!), completed: nil)
            }else{
                self.bottomImage.sd_setImage(with: URL.init(string: banners[index + 1].bgImg!), completed: nil)
            }
            
            self.topImage.sd_setImage(with: URL.init(string: banners[index].bgImg!), completed: nil)
            
            if autoScroll{
                self.startTimer()
            }
        }
        
    }
    
    // 设置PageControll
    func setPageControlImage(){
        if selectImage != nil{
            self.pageControl.currentPageIndicatorImage = selectImage
        }
        if unselectImage != nil{
            self.pageControl.pageIndicatorImage = unselectImage
        }
    }
    
    func startTimer(){
        self.invalidateTimer()
        self.autoScrollIndex  = self.currentIndex()
        timers = Timer.init(timeInterval: scrollInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timers!, forMode: .commonModes)
    }
    
    func invalidateTimer(){
        if timers != nil{
            timers?.invalidate()
            timers = nil
        }
    }
    
    @objc func automaticScroll(){
        if totalItemCount == 0{return}
        let currentIndex = self.currentIndex()
        let targetIndex = currentIndex + 1
        
        let cell = banner.cellForItem(at: IndexPath.init(row: currentIndex, section: 0))
        UIView.animate(withDuration: 0.2, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (finish) in
            self.scrollToIndex(targetIndex: targetIndex)
        }
    }
    
    func scrollToIndex(targetIndex:Int){
        if targetIndex >= totalItemCount{
            banner.scrollToItem(at: IndexPath.init(row: totalItemCount / 2, section: 0), at: [], animated: false)
            return
        }
        banner.scrollToItem(at: IndexPath.init(row: targetIndex, section: 0), at: [], animated: true)
    }
    
    func pageControlIndexWithCurrentCellIndex(index:Int) ->Int{
        return index % self.banners.count
    }
    
    func currentIndex () -> Int {
        if banner.width == 0 || banner.height == 0 {
            return 0
        }
        var index = 0
        index = Int((banner.contentOffset.x + flowLayout.itemSize.width / 2) / flowLayout.itemSize.width)
        return max(0, index)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZPBannerCollectionViewCell", for: indexPath) as! ZPBannerCollectionViewCell
        let itemIndex =  self.pageControlIndexWithCurrentCellIndex(index: indexPath.item)
        let banner = self.banners[itemIndex]
        cell.i_image.sd_setImage(with: URL.init(string: banner.img!), completed: nil)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let curretContentOffset = scrollView.contentOffset.x
        self.pageControl.currentPage = self.pageControlIndexWithCurrentCellIndex(index: self.currentIndex())
        if scrollView.isDragging || scrollView.isDecelerating{
            let itemIndex = self.pageControlIndexWithCurrentCellIndex(index: draggingIndex)
            
            if lastContentOffset > curretContentOffset{
                
                let cell1 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex, section: 0))
                let cell2 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex - 1 < 0 ? totalItemCount: self.draggingIndex - 1, section: 0))
                
                UIView.animate(withDuration: 0.1) {
                    cell1?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    cell2?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                let topIndex = itemIndex - 1 < 0 ? self.banners.count - 1 : itemIndex - 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.leftView.setRaidus(raidus: (mainW * CGFloat(self.draggingIndex) - curretContentOffset) * 2, direction: .right)
                    self.rightView.setRaidus(raidus: 0, direction: .left)
                })
                
            }else{
                
                let cell1 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex, section: 0))
                let cell2 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex + 1 >= totalItemCount ? totalItemCount/2 : draggingIndex + 1, section: 0))
                
                UIView.animate(withDuration: 0.1) {
                    cell1?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    cell2?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                
                let topIndex = itemIndex + 1 > self.banners.count - 1 ? 0 : itemIndex + 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                   self.leftView.setRaidus(raidus: 0, direction: .right)
                    self.rightView.setRaidus(raidus: (mainW * CGFloat(self.draggingIndex) - curretContentOffset) * 2, direction: .left)
                })
            }
        }else{
            let itemIndex = self.pageControlIndexWithCurrentCellIndex(index: autoScrollIndex)
            if lastContentOffset > curretContentOffset{
                
                let cell = banner.cellForItem(at: IndexPath.init(row: autoScrollIndex - 1 < 0 ? totalItemCount : autoScrollIndex - 1, section: 0))
                UIView.animate(withDuration: 0.1, animations: {
                    cell?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                })
                
                let topIndex = itemIndex - 1 < 0 ? self.banners.count - 1 : itemIndex - 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                   self.leftView.setRaidus(raidus: (curretContentOffset - mainW * CGFloat(itemIndex)) * 2, direction: .right)
                    self.rightView.setRaidus(raidus: 0, direction: .left)
                })
                
            }else{
                
                let cell = banner.cellForItem(at: IndexPath.init(row: autoScrollIndex + 1 >= totalItemCount ? totalItemCount/2 : autoScrollIndex + 1, section: 0))
                UIView.animate(withDuration: 0.1, animations: {
                    cell?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                })
                
                let topIndex = (itemIndex + 1) > self.banners.count - 1 ? 0 : itemIndex + 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                   self.leftView.setRaidus(raidus: 0, direction: .right)
                    self.rightView.setRaidus(raidus: (curretContentOffset - mainW * CGFloat(self.autoScrollIndex)) * 2, direction: .left)
                })
            }
            lastContentOffset = curretContentOffset
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.clickBanner(index:))))!{
            delegate?.clickBanner(index: self.pageControlIndexWithCurrentCellIndex(index: indexPath.item))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.draggingIndex = self.currentIndex()
        if self.autoScroll{
            self.invalidateTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll{
            self.startTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //拖动结束后
        lastContentOffset = scrollView.contentOffset.x
        self.autoScrollIndex = self.currentIndex()
        
        let cell1 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex - 1 < 0 ? totalItemCount :  self.autoScrollIndex - 1 , section: 0))
        let cell2 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex , section: 0))
        let cell3 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex + 1 > totalItemCount ? totalItemCount/2 : 0, section: 0))
        
        UIView.animate(withDuration: 0.2) {
            cell1?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell2?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell3?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.autoScrollIndex = self.currentIndex()
        
        let cell1 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex - 1 < 0 ? totalItemCount :  self.autoScrollIndex - 1, section: 0))
        
        let cell2 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex , section: 0))
        let cell3 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex + 1 > totalItemCount ? totalItemCount/2 : 0, section: 0))
        
        UIView.animate(withDuration: 0.2) {
            cell1?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell2?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell3?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    

}
