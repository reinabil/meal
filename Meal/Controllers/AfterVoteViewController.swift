//
//  AfterVoteViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 25/06/22.
//

import UIKit

class AfterVoteViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = UIImage(named: "Illustration_Appreciation")
        label.text = "Woah, cool!\nThank you for finishing all the food. It helps in reducing food waste."
    }
    
    
    @IBAction func okButtonPressed(_ sender: Any) {
    }
}
