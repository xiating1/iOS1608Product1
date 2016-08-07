//
//  UserModel.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/2.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

let defaultUser = UserModel() //最简单的单例

class UserModel: JSONModel {

    var userId :String! = ""
    var token:String! = ""
    var nickname:String! = ""
    var isLogin = false
}
