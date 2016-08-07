//
//  CourseHeader.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/4.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

// CourseHeader 委托方，知道自己高度变化，自己没有办法去改变显示它的空间大小

// CourseDetailController 它中的tableView能够改变 CourseHeader 的显示空间，但是它不知道什么时候改变

protocol CourseHeaderDelegate:class  {
    //更新header的高度
    func updateCourseHeader(header:CourseHeader)->Void
    
    //选中某一集
    func didSelectedIndex(index:NSInteger)->Void
}


class CourseHeader: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    weak var delegate:CourseHeaderDelegate? //声明代理变量，让别人执行协议方法的代价
    
    var courseArray = NSMutableArray() //存放具体的课程详情的数组
    var friendArray = NSMutableArray() // 存放点赞好友数据的数组
    
    var relateArray = NSMutableArray() //存放相关课程的数组
    
    var selectendIndex:NSInteger = 0 // 记录上一次选中的剧集
    var courseId:String! = ""  //选中的剧集的courseId
    
    
    var imageView:UIImageView! //显示菜的图片
    
    var numL:UILabel! //显示上课人数
    var courseNameL:UILabel!//显示名字
    var contentL:UILabel! //显示详细的描叙
    
    var courseView:UIView! //中间显示按钮和 选集  更新 的View
    var updateL:UILabel! //显示更新至的集数
    
    
    var bottomView:UIView! //显示选集按钮下的view
    
    var zanNumL:UILabel!//显示点赞个数
    var zanView:UICollectionView! //显示点赞好友
    
    var relateView:UICollectionView!//显示相关课程
    
    var commentNumL:UILabel! //显示评论条数
    
    let leftSpace:CGFloat = 15
    let topSpace:CGFloat = 8
    
    let space :CGFloat = 5
    var BtnW :CGFloat = 0
    var totalCount:NSInteger = 0
    var showContent:Bool = false  //记录显示内容的按钮状态
    var showCourse:Bool = false  //记录剧集显示状态
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //创建子视图
        self.createSubViews()
    }
    func createSubViews()
    {
        imageView = UIImageView.init(frame: CGRectMake(0, 0, SCREEN_W, 200))
        imageView.userInteractionEnabled = true
        self.addSubview(imageView)
        
        let playerImage = UIImageView.init(frame: CGRectMake(0, 0, 50, 50))
        playerImage.image = UIImage.init(named: "首页-播放")
        //放在图片中心位置
        playerImage.center = imageView.center
        imageView.addSubview(playerImage)
        
        numL = UILabel.init(frame: CGRectMake(leftSpace, imageView.mj_y + imageView.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 23))
        numL.textColor = TEXTGRYCOLOR
        numL.font = UIFont.systemFontOfSize(15)
        self.addSubview(numL)
        
        courseNameL = UILabel.init(frame: CGRectMake(leftSpace, numL.mj_y + numL.mj_h + topSpace, SCREEN_W - leftSpace - 50, 23))
        courseNameL.textColor = UIColor.blackColor()
        courseNameL.font = UIFont.systemFontOfSize(16)
        self.addSubview(courseNameL)
        
        let btn1 = UIButton.init(frame: CGRectMake(SCREEN_W - 40, courseNameL.mj_y, 30, 30))
        btn1.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
        btn1.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)
        btn1.addTarget(self, action: #selector(self.showOrHiddenContent(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btn1)
        
        contentL = UILabel.init(frame: CGRectMake(leftSpace, courseNameL.mj_y + courseNameL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 0))
        contentL.textColor = TEXTGRYCOLOR
        contentL.font = UIFont.systemFontOfSize(14)
        self.addSubview(contentL)
        
        //中间食课列表
        courseView = UIView.init(frame: CGRectMake(0, contentL.mj_y + contentL.mj_h + topSpace, SCREEN_W, 100))
        courseView.backgroundColor = UIColor.whiteColor()
        self.addSubview(courseView)
        
        let xuanL = UILabel.init(frame: CGRectMake(leftSpace, 40, 60, 23))
        xuanL.textColor = UIColor.blackColor()
        xuanL.font = UIFont.systemFontOfSize(17)
        xuanL.text = "选集"
        courseView.addSubview(xuanL)
        
        updateL = UILabel.init(frame: CGRectMake(SCREEN_W - 150, xuanL.mj_y, 100, 23))
        updateL.textColor = TEXTGRYCOLOR
        updateL.textAlignment = NSTextAlignment.Right
        updateL.font = UIFont.systemFontOfSize(16)
        courseView.addSubview(updateL)
        
        let btn2 = UIButton.init(frame: CGRectMake(SCREEN_W - 40, updateL.mj_y, 30, 30))
        btn2.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
        btn2.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)
        btn2.addTarget(self, action: #selector(self.showOrHideenCourseList(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        courseView.addSubview(btn2)
        
        bottomView = UIView.init(frame: CGRectMake(0, courseView.mj_y + courseView.mj_h, SCREEN_W, 200))
        bottomView.backgroundColor = UIColor.whiteColor()
        self.addSubview(bottomView)
        
        zanNumL = UILabel.init(frame: CGRectMake(leftSpace, 40, 150, 23))
        zanNumL.textColor = UIColor.blackColor()
        zanNumL.font = UIFont.systemFontOfSize(16)
        zanNumL.text = "20位厨友觉得很赞"
        bottomView.addSubview(zanNumL)
        
        let btn3 = UIButton.init(frame: CGRectMake(zanNumL.mj_x + zanNumL.mj_w, zanNumL.mj_y - 8, 30, 30))
        btn3.setBackgroundImage(UIImage.init(named: "agree"), forState: UIControlState.Normal)
        btn3.setBackgroundImage(UIImage.init(named: "agree"), forState: UIControlState.Highlighted)
        btn3.addTarget(self, action: #selector(self.dianZan(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(btn3)
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = UICollectionViewScrollDirection.Horizontal
        zanView = UICollectionView.init(frame: CGRectMake(leftSpace, zanNumL.mj_y + zanNumL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 80), collectionViewLayout: layout1)
        zanView.backgroundColor = UIColor.whiteColor()
        zanView.showsHorizontalScrollIndicator = false
        zanView.registerNib(UINib.init(nibName: "FriendCell", bundle: nil), forCellWithReuseIdentifier: "FriendCell")
        zanView.delegate = self
        zanView.dataSource = self
        bottomView.addSubview(zanView)
        
        let relateL = UILabel.init(frame: CGRectMake(leftSpace, zanView.mj_y + zanView.mj_h + topSpace, 100, 23))
        relateL.textColor = UIColor.blackColor()
        relateL.font = UIFont.systemFontOfSize(16)
        relateL.text = "相关课程"
        bottomView.addSubview(relateL)
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionViewScrollDirection.Horizontal
        relateView = UICollectionView.init(frame: CGRectMake(leftSpace, relateL.mj_y + relateL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 160), collectionViewLayout: layout2)
        relateView.registerNib(UINib.init(nibName: "RelateDishCell", bundle: nil), forCellWithReuseIdentifier: "RelateDishCell")
        relateView.delegate = self
        relateView.dataSource = self
        relateView.backgroundColor = UIColor.whiteColor()
        relateView.showsHorizontalScrollIndicator = false
        bottomView.addSubview(relateView)
        
        commentNumL = UILabel.init(frame: CGRectMake(leftSpace, relateView.mj_y + relateView.mj_h, SCREEN_W - 2 * leftSpace, 23))
        commentNumL.textColor = UIColor.blackColor()
        commentNumL.font = UIFont.systemFontOfSize(15)
        commentNumL.text = "20条发言"
        bottomView.addSubview(commentNumL)
        
        let label = UILabel.init(frame: CGRectMake(leftSpace, commentNumL.mj_y + commentNumL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 35))
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textAlignment = NSTextAlignment.Center
        label.text = "课 堂 发 言"
        bottomView.addSubview(label)
        
        bottomView.mj_h = label.mj_y + label.mj_h + topSpace
        
        self.mj_h = bottomView.mj_y + bottomView.mj_h
    }
    //显示或隐藏详细说明文字
    func showOrHiddenContent(button:UIButton)->Void
    {
        
        self.showContent = !self.showContent
        if showContent == true
        {
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Highlighted)
        }else
        {
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)
        }
        
        updateFrames()
    }
    //显示或隐藏16集之后的选集
    func showOrHideenCourseList(button:UIButton)->Void
    {
        
        self.showCourse = !self.showCourse
        if showCourse == true
        {
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Highlighted)
        }else
        {
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)
        }
        updateFrames()
    }
    //MARK:点击显示或隐藏内容 显示或隐藏剧集
    func updateFrames()
    {
        UIView.animateWithDuration(0.4) {
         
            if self.showContent //展示内容
            {
                self.contentL.sizeToFit() //根据文字多少，算出一个刚刚好的高度
                self.courseView.mj_y = self.contentL.mj_y + self.contentL.mj_h + self.topSpace
            }else
            {
                //向上移动，刚好盖住文字
                self.courseView.mj_y = self.contentL.mj_y
            }
            
            // 优化以后
            
            var line = 0
            if self.totalCount % 8 == 0
            {
                line = self.totalCount / 8
            }else
            {
                line = self.totalCount / 8 + 1
            }
            if self.showCourse == false && line > 2
            {
                line = 2
            }
            let H = CGFloat(line) * self.BtnW + CGFloat(line - 1) * self.space + self.updateL.mj_y + self.updateL.mj_h + 10
            self.courseView.mj_h = H
            
            
            
            self.bottomView.mj_y = self.courseView.mj_y + self.courseView.mj_h
            self.mj_h = self.bottomView.mj_y + self.bottomView.mj_h + self.topSpace
        }
        //调用协议方法
        self.delegate?.updateCourseHeader(self)
        
        /*
        if showCourse{
            
            var line = 0
            if self.totalCount % 8 == 0
            {
                line = self.totalCount / 8
            }else
            {
                line = self.totalCount / 8 + 1

            }
            
            let H = CGFloat(line) * BtnW + CGFloat(line - 1) * space + updateL.mj_y + updateL.mj_h + 10
            self.courseView.mj_h = H
        }else
        {
            var line = 0
            if self.totalCount % 8 == 0
            {
                line = self.totalCount / 8
            }else
            {
                line = self.totalCount / 8 + 1
                
            }
            
            if line > 2{
                line = 2
            }
            let H = CGFloat(line) * BtnW + CGFloat(line - 1) * space + updateL.mj_y + updateL.mj_h + 10
            self.courseView.mj_h = H
        }
 */
        
    }
    func dianZan(button:UIButton){
        
    }
    
    func updateSeries(model:SeriesModel){
        
        imageView.sd_setImageWithURL(NSURL.init(string: model.seriesImage))
        let array = model.seriesName.componentsSeparatedByString("#")
        courseNameL.text = array.last
        
        let attr = NSAttributedString.init(string: model.seriesTitle)
        contentL.numberOfLines = 0
        contentL.attributedText = attr
        //自动调整大小
//        contentL.sizeToFit()
    }
    
    func createCourseBtns(count:NSInteger){
        
        BtnW = (SCREEN_W - 2 * leftSpace - 7 * space) / 8
        totalCount = count
        
        for i in 0 ... count - 1{
            
            let orginX = (BtnW + space) * CGFloat(i % 8) + leftSpace
            let orginY = (BtnW + space) * CGFloat(i / 8) + updateL.mj_y + updateL.mj_h + 10
            let button = UIButton.init(frame: CGRectMake(orginX, orginY, BtnW, BtnW))
            button.backgroundColor = GRAYCOLOR
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.setTitle(String(i+1), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(self.btnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            courseView.addSubview(button)
            if i == count - 1
            {
                button.backgroundColor = UIColor.orangeColor()
            }
        }
        self.selectendIndex = count - 1
        //更新选中的显示数据
        self.updateShowIndex(count - 1)
            updateFrames()
 
    }
    func btnClicked(button:UIButton){
       
        let preBtn = self.courseView.viewWithTag(self.selectendIndex + 1000)
        preBtn?.backgroundColor = GRAYCOLOR
        button.backgroundColor = UIColor.orangeColor()
        //更新选中的按钮下标
        self.selectendIndex = button.tag - 1000
        self.updateShowIndex(button.tag - 1000)
    }
    
    //MARK: - 更新显示选中的剧集内容
    func updateShowIndex(index:NSInteger){
        
        //取出相应的剧集模型
        let course = self.courseArray[index] as! CourseModel
        //记录选中的courseId
        self.courseId = course.courseId
        
        self.imageView.sd_setImageWithURL(NSURL.init(string: course.courseImage))
        self.numL.text = "上课人数:\(course.videoWatchcount)"
        //课程描述
        self.contentL.text = course.courseSubject
        //调用detailViewController中的协议方法
        self.delegate?.didSelectedIndex(index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UICollectionView协议方法
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == zanView //显示点赞好友的UICollectionView
        {
            return self.friendArray.count
        }else
        {
            //显示相关课程
            return self.relateArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == zanView
        {
            let cellID = "FriendCell"
            //通过复用ID创建或者查找空闲的cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! FriendCell
            //取出相应的好友数据
            let friend = self.friendArray[indexPath.item] as! FriendModel
            cell.headImage.sd_setImageWithURL(NSURL.init(string: friend.headImg))
            return cell
        }else
        {
            let cellId = "RelateDishCell"
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! RelateDishCell
            let relateCourse = self.relateArray[indexPath.item] as! RelateCourse
            let relation = relateCourse.relation!
            
            cell.dishImage.sd_setImageWithURL(NSURL.init(string: relation.dishesImage))
            cell.title.text = relation.dishesTitle
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if zanView == collectionView{
           
            return CGSizeMake(60, 60)
        }
        return CGSizeMake(130, 150)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
       
        if collectionView == zanView
        {
            return 5
        }
         return 2
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 5
    }
    
}
