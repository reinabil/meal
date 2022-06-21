//
//  TopPartTableViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 15/06/22.
//

import UIKit

protocol TopPartTableViewCellDelegate:AnyObject {
    func buttonClicked(cell: TopPartTableViewCell)
//    func eatButtonPressed(cell: TopPartTableViewCell)
//    func dontEatButtonPressed(cell: TopPartTableViewCell)
}

class TopPartTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var dontEatButton: UIButton!
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    weak var delegate: (TopPartTableViewCellDelegate)?
    
    // empty function
    var eatButtonPressed : (() -> ())?
    var dontEatButtonPressed : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eatButton.backgroundColor = UIColor.systemBackground
        
        //Make background frame rounded
        background.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.buttonClicked(cell: self)
    }
    
    @IBAction func eatButtonPressed(_ sender: UIButton) {
        eatButtonPressed?()
        
        if eatButton.backgroundColor == UIColor.systemBackground {
            eatButton.backgroundColor = UIColor(named: "BrandOrange")
        } else {
            eatButton.backgroundColor = UIColor.systemBackground
        }
    }
    
    @IBAction func dontEatButtonPressed(_ sender: UIButton) {
        dontEatButtonPressed?()
    }
}
