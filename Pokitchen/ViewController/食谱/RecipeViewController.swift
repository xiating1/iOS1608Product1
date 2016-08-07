//
//  RecipeViewController.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/1.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class RecipeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var categoryArray = NSMutableArray()//存放分类
    var dataArray = NSMutableArray()//存放食谱
    
    
    lazy var adView:XTADScrollView = {
       
      let adView = XTADScrollView.init(frame: CGRectMake(0, 0, SCREEN_W, 120))
        //是否需要开启自动轮播
        adView.infiniteLoop = true
        adView.needPageControl = true
        adView.pageControlPositionType = pageControlPositionTypeRight
        return adView
    }()
    
    lazy var tableView:UITableView = {
       
        let table = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49), style: UITableViewStyle.Grouped)
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.tableHeaderView = self.headerView
        table.registerNib(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        
        return table
    }()
    
    lazy var headerView : UIView = {
       
        let headerView = UIView.init(frame: CGRectMake(0, 0, SCREEN_W, 320))
        headerView.addSubview(self.adView)
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

            self.loadData()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func loadData()
    {
        HDManager.startLoading()//开始请求数据，显示加载指示器
        RecipeModel.requestHomeData { (banners, categorys, array, error) in
            
            //刷新UI
            if error == nil
            {
                self.adView.imageURLArray = banners!
                //创建分类button
                self.categoryArray.addObjectsFromArray(categorys!)
                self.createCategoryBtns()
                //加载列表数据
                self.dataArray.addObjectsFromArray(array!)
                self.tableView.reloadData()
            }
            HDManager.stopLoading() //结束网络请求，移除加载指示器
            
        }
    }
    
    func createCategoryBtns()
    {
        let space:CGFloat = 20
        //计算button的宽度
        let btnW = (SCREEN_W - 5 * space) / 4
        var i = 0
        
        let subView = UIView.init(frame: CGRectMake(0, 120, SCREEN_W, 200))
        self.headerView.addSubview(subView)
        
        subView.backgroundColor = UIColor.whiteColor()
        for model in self.categoryArray {
            
            let cateModel = model as! CategoryModel
            let orginX = CGFloat (i % 4) * (btnW + space) + space
            let orginY = CGFloat( i / 4) * (btnW + space) + 5
            let btn = UIButton.init(frame: CGRectMake(orginX, orginY, btnW, btnW))
            //设置背景图片
            btn.sd_setBackgroundImageWithURL(NSURL.init(string: cateModel.image), forState: UIControlState.Normal)
            btn.sd_setBackgroundImageWithURL(NSURL.init(string: cateModel.image), forState: UIControlState.Highlighted)
            btn.setTitle(cateModel.text, forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(12)
            subView.addSubview(btn)
            //设置标题的偏移量
            btn.titleEdgeInsets = UIEdgeInsetsMake(btnW + 20, 0, 0, 0)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(self.categroyBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            i += 1
        }
    }
    
    func categroyBtnClicked(button:UIButton)
    {
       //点击分类时，往下层跳转，对应的接口是分类详情
        //分类按钮被点击
        let model = self.categoryArray.objectAtIndex(button.tag) as! CategoryModel
        let cateVC = CategoryViewController()
        cateVC.categoryId = model.id
        cateVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cateVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - UITableView协议方法

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //组数
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionArray = self.dataArray.objectAtIndex(section) as! [AnyObject]
        //行数
        return sectionArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "RecipeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! RecipeCell
        let array = self.dataArray.objectAtIndex(indexPath.section) as! [RecipeModel]
        let model = array[indexPath.row]
        cell.dishImage.sd_setImageWithURL(NSURL.init(string: model.image))
        cell.detailL.text = model.Description
        cell.titleL.text = model.title
        return cell
        
    }
    //设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    //组头视图
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel.init(frame: CGRectMake(0, 0, SCREEN_W, 25))
        label.backgroundColor = UIColor.whiteColor()
        label.textColor = UIColor.orangeColor()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Right
        
        let array = ["| 热门推荐 >","| 新品推荐 >","| 排行榜 >","| 主题推荐 >"]
        label.text = array[section]
        return label
    }
    
    //返回组头视图的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //找到对应的模型
        let array = self.dataArray[indexPath.section] as! [RecipeModel]
        let model = array[indexPath.row]
        
        //根据地址创建播放源
        let playerItem = AVPlayerItem.init(URL: NSURL.init(string: model.video)!)
        let playerItem1 = AVPlayerItem.init(URL: NSURL.init(string: model.video1)!)
//        AVQueuePlayer 能够播放一组连续的视频、音频的播放器，继承与AVPlayer
        let player = AVQueuePlayer.init(items: [playerItem,playerItem1])
        //创建播放视图控制器
        let avVC = AVPlayerViewController()
        avVC.player = player
        
        self.presentViewController(avVC, animated: true, completion: nil)
        
    }


}
