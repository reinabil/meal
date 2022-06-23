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
    
    let textGrayColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftSideLabel.textColor = .black
        rightSideLabel.textColor = textGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
