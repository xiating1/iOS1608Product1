//
//  CourseDetailModels.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/4.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation


class SeriesModel:JSONModel
{
    var album:String!
    var seriesImage:String!
    var seriesTitle:String!
    var shareUrl:String!
    var seriesName:String!
    
    override class func propertyIsOptional(propertyName:String)->Bool
    {
        return true
    }
    
    override class func keyMapper()->JSONKeyMapper
    {
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    
}

class CourseModel: JSONModel {
    var courseId:String!
    var courseImage:String!
    var courseName:String!
    var courseIntroduce:String!
    var courseSubject:String!
    var courseVideo :String!
    var episode:String!
    var isCollect:String!
    var isLike:String!
    var ischarge:String!
    var price:String!
    var videoWatchcount:String!
    
    override class func  keyMapper()-> JSONKeyMapper
    {
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    
}



class CommentModel: JSONModel {
    
    var content:String!
    var create_time:String!
    var head_img:String!
    var id:String!
    var parents:NSMutableArray?
    var relate_id:String!
    var type:String!
    var user_id:String!
    var istalent:Bool!
    var nick:String!
    var parent_id:String!
    //模型属性和字典的key不匹配时能够正常赋值
    override class func propertyIsOptional(propertyName:String)->Bool
    {
        return true
    }
    required init(dictionary dict: [NSObject : AnyObject]!) throws {
        super.init()
        self.setValuesForKeysWithDictionary(dict as! [String:AnyObject])
        self.parents = nil
        self.parents = NSMutableArray()
        
        let array = dict["parents"] as? [AnyObject]
        if array?.count > 0
        {
            let arr = CommentModel.arrayOfModelsFromDictionaries(array)
            self.parents?.addObjectsFromArray(arr as [AnyObject])
        }

    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    required init(data: NSData!) throws {
        fatalError("init(data:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //计算显示的评论内容
    var attr:NSMutableAttributedString!{
        var atrSring:NSMutableAttributedString? = nil
        let content:NSMutableString = NSMutableString.init(string: "")
        if self.parents?.count > 0
        {
            let praent = self.parents!.lastObject as! CommentModel
            content.appendFormat("回复 %@ : %@", praent.nick,self.content)
            atrSring = NSMutableAttributedString.init(string: content as String)
            //将被回复人的昵称改为橘黄色
            atrSring?.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14),NSForegroundColorAttributeName:UIColor.orangeColor()], range: content.rangeOfString(praent.nick))
            //content.rangeOfString(praent.nick
            //rangeOfString 在一个字符串中查找一个子串，并返回子串的位置
            return atrSring
        }else
        {
            content.appendString(self.content)
            atrSring = NSMutableAttributedString.init(string: content as String)
            return atrSring!
        }
    }
    var cellH :CGFloat{
        
        //给定一个尺寸，宽、高计算一个字符串的大小
        let str = NSString.init(string: self.attr.string)
        
        let rect = str.boundingRectWithSize(CGSizeMake(SCREEN_W - 170, 99999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
        return 70 + rect.size.height
    }
}

/**点赞厨友模型*/
class FriendModel: JSONModel {
    
    var headImg:String!
    var nick:String!
    var userId:String!
    //当用于给对象的变量赋值时，字典中的key名字和模型中的属性名不完全一致时，仍然能够正常赋值，否则有可能崩溃 ，或者模型中的所有属性值都为nil
    override class func propertyIsOptional(propertyName:String)->Bool
    {
        return true
    }
    //是将下划线去掉，并将下划线之后的第一字母大写 head_img -> headImg
    override class func keyMapper()->JSONKeyMapper
    {
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    
}


/**相关课程的模型*/

class RelateCourse: JSONModel {
    var media_id:String!
    var media_type:String!
    var relation:RelationModel?
    //  当模型中有嵌套数组或其他模型时，需要重写 init(dictionary dict: [NSObject : AnyObject]!) throws  处理嵌套的数据
    required init(dictionary dict: [NSObject : AnyObject]!) throws {
        super.init()
        //使用KVC的方法给属性赋值
        self.setValuesForKeysWithDictionary(dict as! [String:AnyObject])
        //特殊处理嵌套的模型
        self.relation = nil
        let relatetion = dict["relation"] as! NSDictionary
        let array = [relatetion]
        //将relatetion 字典转换为RelationModel 的对象
        let models = RelationModel.arrayOfModelsFromDictionaries(array) as [AnyObject]
        self.relation = models.last as? RelationModel
 
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    required init(data: NSData!) throws {
        fatalError("init(data:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RelationModel: JSONModel {
    var dishesId:String!
    var dishesImage:String!
    var dishesTitle:String!
    var materialVideo:String!
    var processVideo:String!
    
    override class func keyMapper()->JSONKeyMapper
    {
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    
}

