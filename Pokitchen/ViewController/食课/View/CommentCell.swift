//
//  CommentCell.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/4.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nickL: UILabel!
    
    
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headImage.layer.cornerRadius = self.headImage.mj_h / 2
        self.headImage.clipsToBounds = true
        
        self.contentL.textColor = TEXTGRYCOLOR
        self.timeL.textColor = TEXTGRYCOLOR
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
