//
//  TalentCell.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/3.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class TalentCell: UICollectionViewCell {

    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nickL: UILabel!
    
    
    @IBOutlet weak var fansL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headImage.layer.cornerRadius = self.headImage.frame.size.height / 2
        //view的裁剪
        self.headImage.clipsToBounds = true
        //在图层上左裁剪
        self.layer.masksToBounds = true
        self.fansL.textColor = TEXTGRYCOLOR
        
    }

}
