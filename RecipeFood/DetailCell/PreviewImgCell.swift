//
//  PreviewImgCell.swift
//  RecipeFood
//
//  Created by TienPV on 12/7/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

class PreviewImgCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var previewImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
