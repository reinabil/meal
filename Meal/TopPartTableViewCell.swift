//
//  TopPartTableViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 15/06/22.
//

import UIKit

class TopPartTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var dontEatButton: UIButton!
    @IBOutlet weak var portionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Make background frame rounded
        background.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
