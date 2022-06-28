//
//  MemberViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 17/06/22.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

class MemberViewController: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var youLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leaveGroupButton: UIButton!
    @IBOutlet weak var notSignInStackView: UIStackView!
    
    let familyID = UserDefaults.standard.string(forKey: "family_id")
    let username = UserDefaults.standard.string(forKey: "username")
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
        
        //Show or hide views based on user SignIn state
        if UserDefaults.standard.bool(forKey: "usersignedin") && Auth.auth().currentUser?.uid != nil {
            notSignInStackView.isHidden = true
            editButton.isHidden = false
            tableView.isHidden = false
            profilePicture.isHidden = false
            youLabel.isHidden = false
        } else {
            notSignInStackView.isHidden = false
            editButton.isHidden = true
            tableView.isHidden = true
            profilePicture.isHidden = true
            youLabel.isHidden = true
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserNameTableViewCell", bundle: nil), forCellReuseIdentifier: "UsernameCell")
        tableView.register(UINib(nibName: "FamilyIDTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyIDCell")
        tableView.register(UINib(nibName: "FamilyMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyMemberCell")
        tableView.backgroundColor = .clear
    }
    
    @IBAction func continueWithAppleButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignIn", sender: self)
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
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsernameCell") as? UserNameTableViewCell else { return UITableViewCell() }
            // Set cell content below
            //cell.leftSideLabel.text = "First Name"
            cell.rightSideLabel.text = username
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyIDCell") as? FamilyIDTableViewCell else { return UITableViewCell() }
            cell.familyIDLabel.text = familyID
            
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell") as? FamilyMemberTableViewCell else { return UITableViewCell() }
            // Set cell content below
            //cell.personProfilePicture.image = UIImage()
            //cell.familyMemberNameLabel.text = "His/Her Name"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = textGrayColor
        header.textLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        header.contentView.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let message = """
                Let's join to our Famealy group:
                \(self.familyID ?? "")
                
                🌭🍞🍕🍗🍱🥪
                Famealy.
                Vote more, waste less.
                """
            let objectsToShare = [message]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
