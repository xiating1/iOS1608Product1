//
//  DishCell.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/2.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class DishCell: UITableViewCell {

    
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var updateL: UILabel!
    
    
    @IBOutlet weak var numL: UILabel!
    
    
    @IBOutlet weak var alumLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateL.textColor = TEXTGRYCOLOR
        self.numL.textColor = TEXTGRYCOLOR
        
        self.contentView.sendSubviewToBack(self.dishImage)
        self.contentView.sendSubviewToBack(self.updateL.superview!)
        //重绘为圆形图片
        self.alumLogo.layer.cornerRadius = self.alumLogo.frame.size.height / 2
        //裁剪掉多余的边界
        self.alumLogo.clipsToBounds = true
        self.numL.superview?.backgroundColor = UIColor.whiteColor()
        
        self.contentView.backgroundColor = GRAYCOLOR
        //去掉选中效果
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
