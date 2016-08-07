//
//  RecommendCell.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/3.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit


//RecommendCell 要显示 CollentViewCell,自己不会创建
//RecommendView 有数据源，能创建CollentViewCell,不会显示

protocol RecommendCellDataSource :class {
    
    //从代理对象中获取要显示的Item个数
    func numberOfItemsInRow(row:Int)->Int
    //从代理对象中获取cell显示
    func cellForItemInRow(row:Int,index:Int,showView:UICollectionView)->UICollectionViewCell
    //从代理对象中获取cell的大小
    func sizeForItemInRow(row:Int,index:Int)->CGSize
}

protocol RecommendCellDelegate:class {
    
    func titleDidSelectedInRow(row:Int)->Void
    
    func itemDidSelectedInRow(row:Int,index:Int)->Void
    
}



class RecommendCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var showView: UICollectionView!
    
    var row:Int = 0 //记录自己被显示时所在的行，现在是RecoomendView中
    
    weak var dataSource : RecommendCellDataSource!
    weak var delegate:RecommendCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.titleViewTaped))
        
        self.titleL.superview?.addGestureRecognizer(tap)
        
        self.showView.backgroundColor = UIColor.whiteColor()
        self.titleL.superview?.backgroundColor = UIColor.whiteColor()
        self.contentView.backgroundColor = GRAYCOLOR
        self.showView.registerNib(UINib.init(nibName: "TalentCell", bundle: nil), forCellWithReuseIdentifier: "TalentCell")
        self.showView.registerNib(UINib.init(nibName: "RecommendDishCell", bundle: nil), forCellWithReuseIdentifier: "RecommendDishCell")
        showView.delegate = self
        showView.dataSource = self
        
    }
    func titleViewTaped(){
        
        self.delegate?.titleDidSelectedInRow(self.row)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UICollectionView协议方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSource!.numberOfItemsInRow(self.row)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return self.dataSource.cellForItemInRow(self.row, index: indexPath.item, showView: self.showView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return self.dataSource.sizeForItemInRow(self.row, index: indexPath.item)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        self.delegate?.itemDidSelectedInRow(self.row, index: indexPath.item)
    }
    
    
}
