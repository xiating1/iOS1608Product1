//
//  HomeTabViewController.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/1.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class HomeTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createViewControllers()
    }

    //MARK:- 创建视图控制器
    func createViewControllers(){
        
        let recipeVC = RecipeViewController()
        let likeVC = LikeViewController()
        let commVC = CommunityViewController()
        let courseVC = CourseViewController()
        let mineVC = MineViewController()
        
        let array = [recipeVC,likeVC,commVC,courseVC,mineVC]
        
        let titleArray = ["食谱","喜欢","社区","食课","我的"]
        
        var navArray = [UINavigationController]()
        var i = 0
        for vc in array
        {
            let nav = UINavigationController.init(rootViewController:vc)
            // 总是显示原色的图片
            let image = UIImage.init(named: titleArray[i] + "A")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            let image1 = UIImage.init(named: titleArray[i] + "B")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            let tabItem = UITabBarItem.init(title: titleArray[i], image: image, selectedImage: image1)
            //设置标题的颜色和字体等属性的方法
            tabItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(12)], forState: UIControlState.Normal)
            tabItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(12),
                //设置选中状态的字体大小和颜色
                NSForegroundColorAttributeName:UIColor.orangeColor()], forState: UIControlState.Selected)
            //NSFontAttributeName 设置字体名字
            
            //设置图片的偏移,上左下右， 设置时上、下一对 ,左右一对
            tabItem.imageInsets  = UIEdgeInsetsMake(8, 0, -8, 0)
            //设置TabBarItem
            nav.tabBarItem = tabItem
            
            navArray.append(nav)
            i += 1
        }
        self.viewControllers = navArray
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
