//
//  RecommendModels.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/3.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation


/**社区模块推荐页面的模型**/

/**轮播视图的图片对应的模型*/
class BannerModel :JSONModel{
    
}

/**掌厨达人模型*/
class TalentModel :JSONModel{
    
    var beFollow:String!
    var headImg:String!
    var istalent:String!
    var nick:String!
    var tongjiBeFollow:String!
    var userId:String!
    
    override class func keyMapper()->JSONKeyMapper
    {
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
}
/**精选作品模型*/
class MarrowModel: JSONModel {
    
    var content:String!
    var Description:String!
    var id:String!
    var image:String!
    var video:String!
    
    override class func keyMapper()->JSONKeyMapper{
        
        return JSONKeyMapper.init(dictionary: ["description":"Description"])
    }
}
/**专题模型*/
class TopicModel :JSONModel
{
    var topic_name:String!
    var id:String!
    var data:NSMutableArray?
    
    required init(dictionary dict: [NSObject : AnyObject]!) throws {
        super.init()
        //用KVC的方法给topic_name、id赋值
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
        self.data = nil
        self.data = NSMutableArray()
        let array = dict["data"] as? [AnyObject]
        if array?.count > 0{
            //将数组中的字典转换为topicDishModel的实例对象，并存放到一个可变数组中返回
            let arr = topicDishModel.arrayOfModelsFromDictionaries(array)
            self.data?.addObjectsFromArray( arr as [AnyObject] )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(data: NSData!) throws {
        fatalError("init(data:) has not been implemented")
    }
}

/**专题菜品模型*/
class topicDishModel: JSONModel {
    
    var agreeCount:String!
    var commentCount:String!
    var content:String!
    var id:String!
    var image:String!
    var userId:String!
    var video:String!
    
    //去掉下划线并将一个字母大写
    override class func keyMapper()->JSONKeyMapper{
        
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }

    override class func propertyIsOptional(propertyName:String)->Bool
    {
        return true
    }
    
}




