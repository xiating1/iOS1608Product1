//
//  CourseModels.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/2.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

/**食课列表模型*/
class DishModel : JSONModel{
    
    var album :String!
    var albumLogo:String!
    var chargeCount:String!
    var episode :String!
    var episodeSum :String!
    var image:String!
    var play:String!
    var seriesId:String!
    var seriesName:String!
    var tag:String!
    
    override class func keyMapper()->JSONKeyMapper
    {
        //aa_bb 变成iOS中我们习惯的 aaBb
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
        //是将aaBb 编码习惯 改成 aa_bb
//        JSONKeyMapper.mapperFromUpperCaseToLowerCase()
    }
}
/**食课列表顶端图标所对应的模型*/
class AlbumModel: JSONModel {
    
    var album:String!
    var albumLogo:String!
    var chargeCount:String!
    var seriesId:String!
    override class func keyMapper()->JSONKeyMapper
    {
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    
    
}