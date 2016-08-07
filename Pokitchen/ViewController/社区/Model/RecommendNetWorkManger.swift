//
//  RecommendNetWorkManger.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/3.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

extension BannerModel{
    
    class func requestRecommendData(callBack:(banner:[AnyObject]?,arrary:[AnyObject]?,error:NSError?)->Void){
        
        //methodName=ShequRecommend&token=&user_id=&version=4.4
        
        let para = NSMutableDictionary.init(dictionary: ["methodName":"ShequRecommend","version":"4.4"])
        if defaultUser.isLogin{
            para.setValue(defaultUser.userId, forKey: "user_id")
            para.setValue(defaultUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
                
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let dic = obj["data"] as! NSDictionary
                
                //解析轮播视图的图片
                let banner = dic["banner"] as? [AnyObject]
                let bannerArray = NSMutableArray()
                if banner?.count > 0{
                    
                    print("在这补上解析轮播视图的代码")
                }
                //有真实数据以后请去掉
                bannerArray.addObject("http://img.szzhangchu.com/1470036538139_9154278269.jpg")
                
                //解析掌厨达人
                
                let talents = dic["shequ_talent"] as? [AnyObject]
                let talentArray = NSMutableArray()
                if talents?.count > 0{
                    let arr = TalentModel.arrayOfModelsFromDictionaries(talents)
                    talentArray.addObjectsFromArray(arr as [AnyObject])
                }
                
                //解析精选作品
                let marrow = dic["shequ_marrow"] as? [AnyObject]
                let marrowArray = NSMutableArray()
                if marrow?.count > 0 {
                    let arr = MarrowModel.arrayOfModelsFromDictionaries(marrow)
                    marrowArray.addObjectsFromArray(arr as [AnyObject])
                }
                //解析专题模型
                
                let topic = dic["shequ_topics"] as? [AnyObject]
                let topicArray = NSMutableArray()
                if topic?.count > 0{
                    let arr = TopicModel.arrayOfModelsFromDictionaries(topic)
                    topicArray.addObjectsFromArray(arr as [AnyObject])
                }
                //将精选作品所有数据插入第一个位置
                topicArray.insertObject(marrowArray, atIndex: 0)
                //将掌厨达人的所有数据插入第一个位置
                topicArray.insertObject(talentArray, atIndex: 0)
                //topicArray 第一个元素是存放着掌厨达人的数组
                //topicArray 第二个元素存放着精选作品的数组
                //topicArray 第三个之后的所有元素都是TopicModel的实例对象
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(banner: bannerArray as [AnyObject],arrary: topicArray as [AnyObject] ,error: nil)
                })
            }else
            {
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(banner: nil,arrary: nil,error: error)
                })
            }
        }
    
    }
}