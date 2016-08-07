//
//  RecipeCell.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/1.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var dishImage: UIImageView!
    
    
    @IBOutlet weak var titleL: UILabel!
    
    
    @IBOutlet weak var detailL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
