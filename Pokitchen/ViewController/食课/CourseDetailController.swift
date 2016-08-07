//
//  CourseDetailController.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/4.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class CourseDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,CourseHeaderDelegate {

    var seriersID:String! //用于请求评论数据、课程列表
    var commentArray = NSMutableArray() //存放评论数据
    var courseArray = NSMutableArray() //存放课程数据
    var seriesModel:SeriesModel?
    lazy var headerView:CourseHeader = {
       
        let headerView = CourseHeader.init(frame: CGRectMake(0, 0, SCREEN_W, 300))
        //指定代理关系
        headerView.delegate = self
        
        return headerView
    }()
    lazy var tableView:UITableView = {
        
        let tableView = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64), style: UITableViewStyle.Plain)
        tableView.registerNib(UINib.init(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headerView
        self.view.addSubview(tableView)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        self.loadCommentData()
        self.loadCourseData()
    }
    //获取评论数据
    func loadCommentData()
    {
        CommentModel.requestData(self.seriersID, page: 1) { (totalCount, array, error) in
            if error == nil
            {
                self.commentArray.addObjectsFromArray(array!)
                self.tableView.reloadData()
                self.headerView.commentNumL.text = "\(totalCount)条发言"
            }
        }
    }
    //请求所有课程数据
    func loadCourseData()
    {
        CommentModel.requestCourses(self.seriersID) { (model, array, error) in
            if error == nil
            {
                self.courseArray.addObjectsFromArray(array!)
                self.seriesModel = model
                self.headerView.updateSeries(model!)
                // 将数据传递个Header ，让它去控制数据显示
                self.headerView.courseArray.addObjectsFromArray(array!)
                //一定先传值，再创建按钮
                self.headerView.createCourseBtns(array!.count)
                //分割名字
                let arr = model?.seriesName.componentsSeparatedByString("#")
                self.navigationItem.title = arr?[1]
                //获取点赞厨友信息
                self.loadFriendData()
                //获取相关课程
                self.loadReloateCourse()

            }
        }
    }
    //获取点赞好友的数据
    func loadFriendData()
    {
        FriendModel.requestFriend(self.headerView.courseId) { (array, error) in
            if error == nil {
                
                self.headerView.friendArray.removeAllObjects()
                self.headerView.friendArray.addObjectsFromArray(array!)
                self.headerView.zanView.reloadData()
            }
        }
        
    }
    
    
    func loadReloateCourse(){
        
        RelateCourse.requestRelateCouse(self.headerView.courseId) { (array, error) in
            if error == nil
            {
                self.headerView.relateArray.removeAllObjects()
                self.headerView.relateArray.addObjectsFromArray(array!)
                self.headerView.relateView.reloadData()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - UITableView协议方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.commentArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "CommentCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! CommentCell
        
        let comment = self.commentArray[indexPath.row] as! CommentModel
        cell.headImage.sd_setImageWithURL(NSURL.init(string: comment.head_img), placeholderImage: UIImage.init(named: "达人"))
        cell.nickL.text = comment.nick
        cell.timeL.text = comment.create_time
        
        cell.contentL.attributedText = comment.attr  //从模型中计算返回
        
        cell.contentL.sizeToFit()//label自动自动适应大小
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let comment = self.commentArray[indexPath.row] as! CommentModel
       return comment.cellH   //在模型中计算了高度
    }
    
    //MARK:- CourseHeader的协议方法
    func updateCourseHeader(header: CourseHeader) {
        
        self.tableView.tableHeaderView = nil
        //更改头的高度
        self.tableView.tableHeaderView = headerView
    }
    func didSelectedIndex(index: NSInteger) {
        //获取好友信息
        self.loadFriendData()
    }
    
}
