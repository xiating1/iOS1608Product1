//
//  QFRefeshHeader.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/2.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class QFRefeshHeader: MJRefreshNormalHeader {

    override func placeSubviews() {
        
        super.placeSubviews()
        self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop - 80;

    }

}
