//
//  HistoryViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 17/06/22.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var summaryBackground: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let dummyData = [
        "June 2022",
        "May 2022",
        "April 2022",
        "March 2022"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        summaryBackground.layer.cornerRadius = 10
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
    }
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dummyData[section]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
