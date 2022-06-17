//
//  UserNameTableViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 17/06/22.
//

import UIKit

class UserNameTableViewCell: UITableViewCell {

    @IBOutlet weak var leftSideLabel: UILabel!
    @IBOutlet weak var rightSideLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
