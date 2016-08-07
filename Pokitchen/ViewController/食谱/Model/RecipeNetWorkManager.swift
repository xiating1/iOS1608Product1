//
//  RecipeNetWorkManager.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/1.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation


extension RecipeModel{
    
    class func requestHomeData(callBack:(banners:[AnyObject]?,categorys:[AnyObject]?,array:[AnyObject]?,error:NSError?)->Void)->Void{
        let para = ["methodName":"HomeIndex"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
//                
                let str = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                print(str!)
                //解析根目录的字典
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                let dict = obj.objectForKey("data") as! NSDictionary
                //解析轮播图片地址
                
                let bannerDic = dict.objectForKey("banner") as! NSDictionary
                let bannerArray = bannerDic.objectForKey("data") as! [AnyObject]
                //用于存放图片地址的数据
                var imageArray = [String]()
                
                for imageDic in bannerArray as! [NSDictionary]{
                    
                    let image = imageDic.objectForKey("image") as! String
                    imageArray.append(image)
                }
                
                //解析分类数据
                //分类数组
                let categoryArray = dict.objectForKey("category")!["data"]
                let cateModels = CategoryModel.arrayOfModelsFromDictionaries(categoryArray as? [AnyObject])
                
                //解析食谱模型
                let dataArray = dict.objectForKey("data") as? [NSDictionary]
                
                let recipeArray = NSMutableArray() //存放四个分组的数组
                
                //遍历解析每一个分组 
                for recipeDic in dataArray!{
                    //存放食谱对应的数组
                    let arr = recipeDic.objectForKey("data") as? [AnyObject]
                    let sectaionArray = RecipeModel.arrayOfModelsFromDictionaries(arr) as [AnyObject]
                    recipeArray.addObject(sectaionArray)
                }
                //NSURLSession发起的请求，系统会开辟一个子线程，并在子线程中去完成下载数据的任务，所有跟UI相关的操作，都应该在主线程队列中执行
                dispatch_async(dispatch_get_main_queue(), {
                    //请求成功的时候回调
                    callBack(banners: imageArray,categorys: cateModels as [AnyObject], array:recipeArray as [AnyObject],error:nil)
                })
                
            }else {
                //失败回调
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(banners: nil,categorys: nil,array: nil,error: error)
                })
            }
        }
    }
    
    
    class func loadKindWithId(Id:String!,page:NSInteger,callBack:(array:[AnyObject]?,totalCount:NSInteger!,error:NSError?)->Void)->Void
    {
        
        let para = ["page":String(page),"methodName":"HomeSerial","serial_id":Id,"size":"10"]
        
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil
            {
                let str = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                print(str!)
                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let data = dict.objectForKey("data") as! NSDictionary
                let recipeArr = data.objectForKey("data")
                let array = RecipeModel.arrayOfModelsFromDictionaries(recipeArr as! [AnyObject])
                let count = data.objectForKey("total") as! String
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: array as [AnyObject],totalCount:NSInteger(count),error:nil)
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: nil,totalCount:0,error:error)
                })
            }
            
        }
        
    }
    
    
    class func searchKind(kindId:String!,page:NSInteger,callBack:(array:[AnyObject]?,totalCount:NSInteger?, error:NSError?)->Void)->Void{
        let  para = ["methodName":"CategorySearch","page":String(page),"cat_id":kindId,"type":"1","size":"10"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil
            {
                let str = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                print(str!)
                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let data = dict.objectForKey("data") as! NSDictionary
                let recipeArr = data.objectForKey("data")
                let array = RecipeModel.arrayOfModelsFromDictionaries(recipeArr as! [AnyObject])
                let count = data.objectForKey("total") as! String
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: array as [AnyObject],totalCount:NSInteger(count),error:nil)
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: nil,totalCount:0,error:error)
                })
            }
            
        }
        
    }
    
}

