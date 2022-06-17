//
//  HistoryTableViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 17/06/22.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var leftSideImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
