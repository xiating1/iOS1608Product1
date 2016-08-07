//
//  CourseDetailNetWorkManger.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/4.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation


extension CommentModel{
    
    class func requestData(relateId:String!,page:NSInteger,callBack:(totalCount:NSInteger,array:[AnyObject]?,error:NSError?)->Void){
        
        let para = NSMutableDictionary.init(dictionary: ["methodName":"CommentList","page":"1","relate_id":relateId,"size":"99999","type":"2","version":"4.4"])
        if defaultUser.isLogin {
            para.setObject(defaultUser.userId, forKey: "user_id")
            para.setObject(defaultUser.token, forKey: "token")
        }
        
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
                
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let dic = obj["data"] as! NSDictionary
                //解析评论
                let array = dic["data"] as? [AnyObject]
                
                let modelArray = NSMutableArray()
                
                if array?.count > 0 {
                   let arr  = CommentModel.arrayOfModelsFromDictionaries(array)
                    modelArray.addObjectsFromArray(arr as[AnyObject])
                }
                
                let count = NSInteger(dic["total"] as! String)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(totalCount: count!, array:modelArray as [AnyObject],error:nil)
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(totalCount:0,array: nil,error: error)
                })
            }
        }
    }
    //获取所有课程数据
    class func requestCourses(seriesId:String!,callBack:(model:SeriesModel?,array:[AnyObject]?,error:NSError?)->Void){
        
        let para = NSMutableDictionary.init(dictionary: ["methodName":"CourseSeriesView","series_id":seriesId,"version":"4.4"])
        if defaultUser.isLogin
        {
            para.setValue(defaultUser.userId, forKey: "user_id")
            para.setValue(defaultUser.token, forKey: "token")
        }
        
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil
            {
               let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                let dic = obj["data"] as! NSDictionary
                
                //解析系列模型
                let array = [dic]
                let models = SeriesModel.arrayOfModelsFromDictionaries(array)
                let seriModel = models.lastObject as! SeriesModel
                
                //解析课程模型
                let courses = dic["data"] as? [AnyObject]
                let modelArray = NSMutableArray()
                
                if courses?.count > 0
                {
                    let arr = CourseModel.arrayOfModelsFromDictionaries(courses)
                    modelArray.addObjectsFromArray(arr as [AnyObject])
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    
                    callBack(model: seriModel,array:  modelArray as [AnyObject],error: nil)
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(model:nil,array: nil,error: error)
                })
            }
        }
    }
}

extension FriendModel{
    
    class func requestFriend(courseId:String!,callBack:(array:[AnyObject]?,error:NSError?)->Void){
        
        
        let para = NSMutableDictionary.init(dictionary: ["media_type":"3","methodName":"DianzanList","page":"1","size":"99999","version":"4.4","post_id":courseId])
        if defaultUser.isLogin{
            //如果已经登录，加入登陆后的参数
            para.setObject(defaultUser.userId, forKey: "user_id")
            para.setObject(defaultUser.token, forKey: "token")
        }
        
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
              //获取Json数据根目录数据
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //取得存放好友信息的数组
                let array = obj["data"]!["data"] as? [AnyObject]
                //用于存放好友模型的数组
                let modelArray = NSMutableArray()
                if array?.count > 0{
                    
                    //使用 FriendModel 模型名去调用arrayOfModelsFromDictionaries  在此方法中，实际上就是遍历数组中的字典，初始化FriendModel 的对象，并用字典中key的值去给模型的属性赋值，最后将遍历得到的所有模型放到一个可变数组中，并返回
                    
                    let arr = FriendModel.arrayOfModelsFromDictionaries(array)
                    modelArray.addObjectsFromArray(arr as [AnyObject])
           
                }
                dispatch_async(dispatch_get_main_queue(), {
                    callBack(array: modelArray as [AnyObject],error: nil)
                })
            }else
            {
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: nil,error: error)
                })
            }
        }
    }
}

