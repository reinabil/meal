//
//  MemberViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 17/06/22.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leaveGroupButton: UIButton!
    
    let textGrayColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
    let sections = [
        ["USERNAME", ["First Name", "Last Name"]],
        ["FAMILY ID", ["FM001"]],
        ["OTHER FAMILY MEMBERS", ["John Doe (Me)", "Dad Name", "Mother Name"]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserNameTableViewCell", bundle: nil), forCellReuseIdentifier: "UsernameCell")
        tableView.register(UINib(nibName: "FamilyIDTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyIDCell")
        tableView.register(UINib(nibName: "FamilyMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyMemberCell")
        tableView.backgroundColor = .clear
    }
}

extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let content = sections[section][1] as? [String]
        return content?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section][0] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "UsernameCell") as? UserNameTableViewCell
            // Set cell content below
//            cell.leftSideLabel.text = "First Name"
            //cell.rightSideLabel.text = "John"
            
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "FamilyIDCell") as? FamilyIDTableViewCell
            // Set cell content below
//            cell.familyIDLabel.text = "ABC123"
            
        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell") as? FamilyMemberTableViewCell
            // Set cell content below
            //cell.personProfilePicture.image = UIImage()
            //cell.familyMemberNameLabel.text = "His/Her Name"
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = textGrayColor
        header.textLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        header.contentView.backgroundColor = .white
    }
}

//MARK: - family_id
//UserDefaults.standard.string(forKey: "family_id")

//MARK: - username
//UserDefaults.standard.string(forKey: "username")

//MARK: - SHARE FUNCTION
//Set the default sharing message.
//let message = """
//    Let's join to our Famealy group:
//    \(self.family_id ?? "")
//
//    🌭🍞🍕🍗🍱🥪
//    Famealy.
//    Vote more, waste less.
//    """
//let objectsToShare = [message]
//let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//self.present(activityVC, animated: true, completion: nil)
