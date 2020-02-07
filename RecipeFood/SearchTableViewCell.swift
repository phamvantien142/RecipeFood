//
//  searchTableViewCell.swift
//  RecipeFood
//
//  Created by TienPV on 12/6/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSearchNbReserving: UILabel!
    @IBOutlet weak var lblSearchLevel: UILabel!
    @IBOutlet weak var lblSearchTitle: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
