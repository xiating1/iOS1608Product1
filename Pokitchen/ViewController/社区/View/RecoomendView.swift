//
//  RecoomendView.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/3.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class RecoomendView: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource,RecommendCellDataSource,RecommendCellDelegate {
    
    weak var delegate:CommunityDelegate?//用于推出下一层视图控制器
    var bannerArray = NSMutableArray()
    var dataArray = NSMutableArray()
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49), style: UITableViewStyle.Plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNib(UINib.init(nibName: "RecommendCell", bundle: nil), forCellReuseIdentifier: "RecommendCell")
        self.contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headerView
        return tableView
    }()
    
    lazy var headerView : XTADScrollView = {
        let adView = XTADScrollView.init(frame: CGRectMake(0, 0, SCREEN_W, 120))
        adView.infiniteLoop = true
        adView.needPageControl = true
        adView.pageControlPositionType = pageControlPositionTypeRight
        return adView
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = GRAYCOLOR
        self.loadData()
    }
    
    func loadData(){
     
        HDManager.startLoading()
        BannerModel.requestRecommendData { (banner, arrary, error) in
            if error == nil
            {
                self.bannerArray.addObjectsFromArray(banner!)
                self.dataArray.addObjectsFromArray(arrary!)
                self.tableView.reloadData()
                self.headerView.imageURLArray = self.bannerArray as [AnyObject]
            }
            HDManager.stopLoading()
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UITableView协议方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "RecommendCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! RecommendCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //记录显示所在的行
        cell.row = indexPath.row
        cell.dataSource = self
        cell.delegate = self
        //刷新所有数据
        cell.showView.reloadData()
        
        if indexPath.row == 0
        {
            cell.titleL.text = "掌厨达人"
            cell.icon.image = UIImage.init(named: "达人")
        }else if indexPath.row == 1
        {
            cell.titleL.text = "精选作品"
            cell.icon.image = UIImage.init(named: "精品")
        }else
        {
            let model = self.dataArray[indexPath.row] as! TopicModel
            cell.titleL.text = model.topic_name
            cell.icon.image = UIImage.init(named: "标签")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 185
    }
    
    //MARK: - RecommendCellDataSource 协议方法
    
    func numberOfItemsInRow(row: Int) -> Int {
        
        if row == 0 || row == 1
        {
            let array = self.dataArray[row] as! [AnyObject]
            
            return array.count
        }else
        {
            let topModel = self.dataArray[row] as! TopicModel
            
            return topModel.data!.count
        }
    }
    
    func cellForItemInRow(row: Int, index: Int, showView: UICollectionView) -> UICollectionViewCell {
        
        if row == 0
        {
            //掌厨达人
            let array = self.dataArray[row] as! [TalentModel]
            //取出对应的掌厨达人模型
            let talent = array[index]
            
            let cellId = "TalentCell"
            let cell = showView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: NSIndexPath.init(forItem: index, inSection: 0)) as! TalentCell
            //设置头像图片
            cell.headImage.sd_setImageWithURL(NSURL.init(string: talent.headImg))
            cell.nickL.text = talent.nick
            cell.fansL.text = "粉丝人数:\(talent.tongjiBeFollow)"
            return cell
            
        }else if row == 1 {
            //精选作品
            
            let array = self.dataArray[row] as! [MarrowModel]
            let model = array[index]
            let cell = showView.dequeueReusableCellWithReuseIdentifier("RecommendDishCell", forIndexPath: NSIndexPath.init(forItem: index, inSection: 0)) as! RecommendDishCell
            //设置精选作品的图片
            cell.dishImage.sd_setImageWithURL(NSURL.init(string: model.image))
            return cell
        }else
        {
            //专题作品
            
            let topicModel = self.dataArray[row] as! TopicModel
            
            let data = topicModel.data
            
            let dish = data![index] as! topicDishModel
            
            let cell = showView.dequeueReusableCellWithReuseIdentifier("RecommendDishCell", forIndexPath: NSIndexPath.init(forItem: index, inSection: 0)) as! RecommendDishCell
            cell.dishImage.sd_setImageWithURL(NSURL.init(string: dish.image))
            
            return cell
        }
        
    }
    
    func sizeForItemInRow(row: Int, index: Int) -> CGSize {
        
        return CGSizeMake(130, 130)
    }
    //RecommendCellDelegate协议方法
    
    func titleDidSelectedInRow(row: Int) {
        
        print("title被点击")
        if row == 0
        {
            let talentVC = TalentViewController()
            self.delegate?.pushToViewController(talentVC)
        }
    }
    
    func itemDidSelectedInRow(row: Int, index: Int) {
        
        print("item被点击")
    }
    
    
    
}
