//
//  CourseViewController.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/1.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var albumArray = NSMutableArray()//存放顶端图片模型的数组
    var page:NSInteger = 1
    
    var dataArray = NSMutableArray()//存放数据源
    lazy var tableView : UITableView = {
       
        let tableView = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49), style: UITableViewStyle.Plain)
        tableView.registerNib(UINib.init(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "DishCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.header = QFRefeshHeader.init(refreshingBlock: {
            self.page = 1
            self.loadDishData()
        })
        
        tableView.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { 
            self.page += 1
            self.loadDishData()
        })
        //留出上方的图标所占的位置
        tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    lazy var  albumView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        //设置滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 5
        let albumView = UICollectionView.init(frame: CGRectMake(0, 64, SCREEN_W, 80), collectionViewLayout: layout)
        albumView.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.7)
        albumView.showsHorizontalScrollIndicator = false
        
        albumView.registerNib(UINib.init(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCell")
        albumView.delegate = self
        albumView.dataSource = self
        self.view.addSubview(albumView)
        return albumView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadDishData()
        self.loadAlbums()
        
    }
    
    func loadAlbums()
    {
        HDManager.startLoading()
        AlbumModel.request { (array, error) in
            
            if error == nil{
                self.albumArray.addObjectsFromArray(array!)
                self.albumView.reloadData()
            }
            HDManager.stopLoading()
        }
    }
    
    //MARK:- 请求列表数据
    func loadDishData()
    {
        HDManager.startLoading()
        DishModel.requestDish(self.page) { (array, error) in
            if error == nil{
                
                if self.page == 1
                {
                    self.dataArray.removeAllObjects()
                }
                self.dataArray.addObjectsFromArray(array!)
                self.tableView.reloadData()
                self.tableView.footer.endRefreshing()
                self.tableView.header.endRefreshing()
                self.view.sendSubviewToBack(self.tableView)
            }
            HDManager.stopLoading()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - UITableView 协议方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "DishCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! DishCell
        let model = self.dataArray[indexPath.row] as! DishModel
        
        cell.dishImage.sd_setImageWithURL(NSURL.init(string: model.image))
        cell.alumLogo.sd_setImageWithURL(NSURL.init(string: model.albumLogo))
        let arr = model.seriesName.componentsSeparatedByString("#")
        cell.nameL.text = arr.last
        cell.updateL.text = "更新至\(model.episode)集"
        cell.numL.text = "上课人数:\(model.play)"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 240
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.dataArray[indexPath.row] as! DishModel
        print(model.seriesId)
        
        let detailVC = CourseDetailController()
        detailVC.seriersID = model.seriesId
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    //MARK:- UICollectionView协议方法
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.albumArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellID = "AlbumCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! AlbumCell
        let model = self.albumArray[indexPath.item] as! AlbumModel
        cell.albumLogo.sd_setImageWithURL(NSURL.init(string: model.albumLogo))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(60, 60)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.albumArray[indexPath.item] as! AlbumModel
        print("跳转详情%@",model.seriesId)
        
        let detailVC = CourseDetailController()
        detailVC.seriersID = model.seriesId
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
