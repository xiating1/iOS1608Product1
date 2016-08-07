//
//  FriendCell.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/5.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class FriendCell: UICollectionViewCell {

    
    @IBOutlet weak var headImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headImage.layer.cornerRadius = self.headImage.frame.size.height / 2
        self.headImage.clipsToBounds = true
    }
}
