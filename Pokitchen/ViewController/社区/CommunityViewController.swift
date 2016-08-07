//
//  CommunityViewController.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/1.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit


protocol CommunityDelegate:class {
    
    func pushToViewController(vc:UIViewController)->Void
}


class CommunityViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NavTitleViewDelegate,CommunityDelegate {

    var titleView : NavTitleView!
    var collentionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCollentionView()
        self.createTitleView()
        titleView.setIndex(1)
    }
    func createTitleView(){
        titleView = NavTitleView.init(frame: CGRectMake(80, 20, SCREEN_W - 160, 44), titleArray: ["关注","推荐","最新"])
        //指定代理对象
        titleView.delegate = self
        self.navigationItem.titleView = titleView
    }
    
    func titleDidSelectedAtIndex(index: NSInteger) {
        
        collentionView.contentOffset = CGPointMake(CGFloat(index) * SCREEN_W, 0)
    }
    
    func createCollentionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collentionView = UICollectionView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49), collectionViewLayout: layout)
        collentionView.showsHorizontalScrollIndicator = false
        collentionView.delegate = self
        collentionView.dataSource = self
        
        collentionView.registerClass(AttentionView.self, forCellWithReuseIdentifier: "AttentionView")
        collentionView.registerClass(RecoomendView.self, forCellWithReuseIdentifier: "RecoomendView")
        collentionView.registerClass(NewestView.self, forCellWithReuseIdentifier: "NewestView")
        collentionView.pagingEnabled = true
        self.view.addSubview(collentionView)
        self.automaticallyAdjustsScrollViewInsets = false
        collentionView.backgroundColor = GRAYCOLOR
        collentionView.contentOffset = CGPointMake(SCREEN_W, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0
        {
            let cellID = "AttentionView"
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! AttentionView
            return cell
            
        }else if indexPath.item == 1
        {
            let cellID = "RecoomendView"
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! RecoomendView
            //指定推出下一层视图的代理
            cell.delegate = self
            return cell
        }else
        {
            let cellID = "NewestView"
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! NewestView
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(SCREEN_W, SCREEN_H - 64 - 49)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / SCREEN_W
        
        titleView.setIndex(NSInteger(index))
    }
    
    //MARK:- CommunityDelegate协议方法
    
    func pushToViewController(vc: UIViewController) {
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
