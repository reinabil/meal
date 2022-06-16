//
//  VoteViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 16/06/22.
//

import UIKit

class VoteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewFooterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Register XIB and set tableView delegate and dataSource to self
        tableView.register(UINib(nibName: "TopPartTableViewCell", bundle: nil), forCellReuseIdentifier: "topCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension VoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topCell") as? TopPartTableViewCell else { return UITableViewCell() }
        
        // Set foodName, portion, and button state here (Example code below)
        //
        //cell.foodNameLabel.text = "foodName"
        //cell.portionLabel.text = "Portion: xx"
        //cell.eatButton or cell.dontEatButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //change to amount of food from database
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

