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
    
    var emptyStateContainerView: UIView!
    var emptyStateTopLabel: UILabel!
    var emptyStateBottomLabel: UILabel!
    
    // Summary dibuat ke dalam tableView?
    let dummyData: [String] = [
        "June 2022",
        "May 2022",
        "April 2022",
        "March 2022"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        summaryBackground.layer.cornerRadius = 10
        summaryBackground.backgroundColor = UIColor(named: "BrandLightGray")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        tableView.backgroundColor = UIColor.white
        setupTableViewBackground()
    }
    
    //Background for empty state
    func setupTableViewBackground() {
        emptyStateContainerView = UIView()
        
        emptyStateTopLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 232, height: 24))
        emptyStateTopLabel.text = "History is Empty"
        emptyStateTopLabel.textColor = .black
        emptyStateTopLabel.textAlignment = .center
        emptyStateTopLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        emptyStateContainerView?.addSubview(emptyStateTopLabel)
        
        emptyStateBottomLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 232, height: 24))
        emptyStateBottomLabel.text = "Start adding and voting meal"
        emptyStateBottomLabel.textColor = .black
        emptyStateBottomLabel.textAlignment = .center
        emptyStateBottomLabel.numberOfLines = 0
        emptyStateBottomLabel.font = UIFont(name: "Poppins-Regular", size: 12)
        emptyStateContainerView?.addSubview(emptyStateBottomLabel)
        
        emptyStateTopLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateBottomLabel?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateTopLabel.centerXAnchor.constraint(equalTo: emptyStateContainerView.centerXAnchor),
            emptyStateTopLabel.centerYAnchor.constraint(equalTo: emptyStateContainerView.centerYAnchor),
            emptyStateBottomLabel.topAnchor.constraint(equalTo: emptyStateTopLabel.topAnchor, constant: 25),
            emptyStateBottomLabel.centerXAnchor.constraint(equalTo: emptyStateTopLabel.centerXAnchor),
            emptyStateBottomLabel.leftAnchor.constraint(equalTo: emptyStateContainerView.leftAnchor, constant: 16),
            emptyStateBottomLabel.rightAnchor.constraint(equalTo: emptyStateContainerView.rightAnchor, constant: -16)
        ])
        
        tableView.backgroundView = emptyStateContainerView
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
        tableView.backgroundView?.isHidden = (dummyData.count > 0) ? true : false
        
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dummyData[section]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        header.contentView.backgroundColor = .white
    }
}
