//
//  VoterCollectionViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 15/06/22.
//

import UIKit

class VoterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Make background image frame rounded
        cellBackground.layer.cornerRadius = cellBackground.frame.height/2
    }

}
