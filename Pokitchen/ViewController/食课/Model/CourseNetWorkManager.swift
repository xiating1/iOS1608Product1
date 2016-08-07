//
//  CourseNetWorkManager.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/2.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

extension DishModel{
    
    class func requestDish(page:NSInteger,callBack:(array:[AnyObject]?,error:NSError?)->Void){
        
        let para = NSMutableDictionary.init(dictionary: ["methodName":"CourseIndex","page":String(page),"size":"10","version":"4.4"])
        if  defaultUser.isLogin {
            
            para.setValue(defaultUser.userId, forKey: "user_id")
            para.setValue(defaultUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil
            {
              
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let dic = obj["data"] as! NSDictionary
                let array = dic["data"] as? [AnyObject]
                let modelArray = NSMutableArray()//存放解析得到的模型数组
                if array?.count > 0{
                    
                    modelArray.addObjectsFromArray(DishModel.arrayOfModelsFromDictionaries(array) as [AnyObject])
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array:modelArray as [AnyObject],error: nil)
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
/**食课顶端图片数据的请求*/
extension AlbumModel{
    
 
    class func request(callBack:(array:[AnyObject]?,error:NSError?)->Void){
        

        
        let para = NSMutableDictionary.init(dictionary: ["methodName":"CourseLogo","version":"4.4"])
        if defaultUser.isLogin {
            para.setValue(defaultUser.userId, forKey: "user_id")
            para.setValue(defaultUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil {
                
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                let array = obj["data"]!["albums"] as? [AnyObject]
                
                let modelArray = NSMutableArray()
                
                if array?.count > 0 {
                    //将数组array中的所有字典转换为AlbumModel的实例对象，并添加到modelArray中
                    modelArray.addObjectsFromArray(AlbumModel.arrayOfModelsFromDictionaries(array) as [AnyObject])
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array:modelArray as [AnyObject],error: nil)
                })
               
            }else {
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: nil,error: error)
                })
            }
        }
    }
}

extension RelateCourse{
    
    class func requestRelateCouse(courseId:String!,callBack:(array:[AnyObject]?,error:NSError?)->Void)
    {
       
        
        let para = NSMutableDictionary.init(dictionary: ["course_id":courseId,"methodName":"CourseRelate","page":"1","size":"9999","version":"4.4"])
        
        if defaultUser.isLogin
        {
            para.setObject(defaultUser.userId, forKey: "user_id")
            para.setObject(defaultUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
              
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let array = obj["data"]!["data"] as? [AnyObject]
                //存放模型的数组
                let modelArray = NSMutableArray()
                if array?.count > 0
                {
                    modelArray.addObjectsFromArray(RelateCourse.arrayOfModelsFromDictionaries(array) as [AnyObject])
                    // RelateCourse.arrayOfModelsFromDictionaries
                    // 使用RelateCourse类名去调用，说明要讲数组中的字典对应解析为RelateCourse的对象，会遍历字典，一个字典对应创建一个对象
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

