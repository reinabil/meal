//
//  FamilyMemberTableViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 17/06/22.
//

import UIKit

class FamilyMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var personProfilePicture: UIImageView!
    @IBOutlet weak var familyMemberNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
