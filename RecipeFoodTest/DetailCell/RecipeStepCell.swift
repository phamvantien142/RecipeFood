//
//  RecipeStepCell.swift
//  RecipeFoodTest
//
//  Created by TienPV on 12/7/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

class RecipeStepCell: UITableViewCell{

    @IBOutlet weak var BgImageView: UIImageView!
    @IBOutlet weak var lblStepDescription: UILabel!
    @IBOutlet weak var lblStepIndex: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
