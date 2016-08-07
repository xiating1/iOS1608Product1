//
//  RecipeModels.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/1.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

/**食谱模块的所有模型*/

/**分类模型*/
class CategoryModel : JSONModel{
    var id:String!
    var image:String!
    var text:String!
    
}

/**食谱模型*/
class RecipeModel:JSONModel
{
    var content:String!
    var Description:String!
    var id:String!
    var image:String!
    var title:String!
    var video:String!
    var video1:String!
    var tagsInfo:NSMutableArray?
    //当模型的属性和字典中的key值个数不匹配时，实现以下这个方法，返回真，当赋值遇到不匹配的属性时跳过继续赋值
    override class func propertyIsOptional(propertyName:String)->Bool
    {
        return true
    }
    override class func keyMapper()->JSONKeyMapper
    {
        //返回这个类解析是属性的对应编码 将原字典中为改变的名字作为key,把类的属性名作为Value
        return JSONKeyMapper.init(dictionary: ["description":"Description","tags_info":"tagsInfo"])
    }
    
    required init(dictionary dict: [NSObject : AnyObject]!) throws {
        super.init()
        //调用KVC赋值
        self.setValuesForKeysWithDictionary(dict as! [String:AnyObject])
        //用KVC赋值之后，tagsInfo 是一个数组，数组中存放的是字典，我们要把其中的字典转换为对应的模型
        let array = dict["tags_info"] as? [AnyObject]
        self.tagsInfo = nil
        self.tagsInfo = NSMutableArray()
        if array?.count > 0 {
            //将array 中的字典转换为TagInfoModel 类的对象
            let tagModels = TagInfoModel.arrayOfModelsFromDictionaries(array)
            self.tagsInfo?.addObjectsFromArray(tagModels as [AnyObject])
        }
        // 如果遇到模型中的一个属性是数组、模型时才需要这样的处理
        
    }
    //放在遇到未定义的属性时崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    required init(data: NSData!) throws {
        fatalError("init(data:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/**标记菜系的模型*/
class TagInfoModel: JSONModel {
    
    var id:String!
    var text:String!
    var type:String!
}

