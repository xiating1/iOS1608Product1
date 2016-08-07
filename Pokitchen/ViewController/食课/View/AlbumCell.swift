//
//  AlbumCell.swift
//  Pokitchen
//
//  Created by 夏婷 on 16/8/2.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    @IBOutlet weak var albumLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.albumLogo.layer.cornerRadius = self.albumLogo.frame.size.height / 2
        self.albumLogo.clipsToBounds = true
    }

}
