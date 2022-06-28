//
//  VoteViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 16/06/22.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore


class VoteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewFooterView: UIView!
    @IBOutlet weak var tableViewFooterButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var menuArray: Array<Any>?
    var menu: [Menu] = []
    var like: [Like] = []
    var allLike: [Like] = []
    var dislike: [Dislike] = []
    
    var portions = 0
    
    var isLeftFood: Bool?
    
    //Dummy data, change with real data later
    var tableViewData = DataSeeder.sharedData
    //Variable to store expanded tableViewCell data
    var openedCellSections: [IndexPath] = []
    var openedCellDataIndex: [Int] = []
    
    let defaults = UserDefaults.standard
    var db: Firestore!
    var family_id = ""
    
    var emptyStateContainerView: UIView!
    var emptyStateTopLabel: UILabel!
    var emptyStateBottomLabel: UILabel!
    
    var isFromCreateFamily = false
    
    override func viewDidLoad() {
        
        // reset user defaults
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        
        if UserDefaults.standard.string(forKey: "family_id") != nil || UserDefaults.standard.string(forKey: "family_id") != "" {
            family_id = UserDefaults.standard.string(forKey: "family_id") ?? ""
        }
     
        super.viewDidLoad()

        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        //Register XIB and set tableView delegate and dataSource to self
        tableView.register(UINib(nibName: "TopPartTableViewCell", bundle: nil), forCellReuseIdentifier: "topCell")
        tableView.register(UINib(nibName: "BottomPartTableViewCell", bundle: nil), forCellReuseIdentifier: "bottomCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        setupTableViewBackground()
        setupTableViewFooterButton()
        
        if UserDefaults.standard.string(forKey: "family_id") == nil || UserDefaults.standard.string(forKey: "family_id") == "" {
//            tableView.isHidden = true
            
            // insert empty label
        } else {
            
            // insert table
            
//            tableView.isHidden = false
            
            loadLike()
            loadAllLike()
            loadDisike()
            loadMenu()
        }
    }
    
    func setupTableViewFooterButton() {
        tableViewFooterButton.layer.borderWidth = 2
        tableViewFooterButton.layer.borderColor = CGColor(red: 250/255, green: 90/255, blue: 39/255, alpha: 1)
        tableViewFooterButton.layer.cornerRadius = tableViewFooterButton.frame.height/2
    }
    
    //Background for empty state
    func setupTableViewBackground() {
        emptyStateContainerView = UIView()
        
        emptyStateTopLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 232, height: 24))
        emptyStateTopLabel.text = "You don’t have any meal yet."
        emptyStateTopLabel.textColor = .black
        emptyStateTopLabel.textAlignment = .center
        emptyStateTopLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        emptyStateContainerView?.addSubview(emptyStateTopLabel)
        
        emptyStateBottomLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 232, height: 24))
        emptyStateBottomLabel.text = "Add meal to vote and see who’s eating and how many portions to cook"
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
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        //Check if there is any cell that is expanded
        if openedCellSections.count > 0 {
            //Set each element's isOpened property to false (collapse it)
            for i in 0...openedCellSections.count-1 {
                menu[openedCellDataIndex[i]].isOpened = false
                let section = IndexSet.init(integer: openedCellSections[i].section)
                tableView.reloadSections(section, with: .none)
            }
        }
        
        openedCellSections.removeAll()
        openedCellDataIndex.removeAll()
        
        //Set tableView to editing mode
        tableView.setEditing((tableView.isEditing) ? false : true, animated: true)
        sender.setTitle((tableView.isEditing) ? "Cancel" : "Edit", for: .normal)
        addButton.setTitle((tableView.isEditing) ? "Done" : "Add Meal", for: .normal)
        
        //Change footer button text and appearance based on current state of tableView
        if tableView.isEditing {
            tableViewFooterButton.titleLabel?.text = "Delete All"
            tableViewFooterButton.titleLabel?.textColor = UIColor.red
            tableViewFooterButton.titleLabel?.textAlignment = .center
            tableViewFooterButton.layer.borderWidth = 0
        } else {
            tableViewFooterButton.titleLabel?.text = "New Meal List"
            tableViewFooterButton.titleLabel?.textColor = UIColor(named: "BrandOrange")
            setupTableViewFooterButton()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        // kalo sudah login
        if UserDefaults.standard.bool(forKey: "usersignedin") && Auth.auth().currentUser?.uid != nil {
            print("Add ITEM")
            
            //klo udh login tp belom masukin family id
            let docRef = db.collection("user").document("\(Auth.auth().currentUser!.uid)")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    
                    // ADD DATA MENU
                    print("Document data: \(dataDescription)")
                    print("\(document.get("family_id") ?? "")")
                    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
                    var textField = UITextField()
                    
                    let action = UIAlertAction(title: "Add item", style: .default, handler: { (action) in
                        
                        if textField.text != "" {
                            
                            // Add a new document with a generated id.
                            let ref = self.db.collection("menu").document()
                            
                            ref.setData([
                                "name": "\(textField.text ?? "")",
                                "family_id": "\(UserDefaults.standard.string(forKey: "family_id") ?? "")",
                                "portions": 0,
                                "date": Date().timeIntervalSince1970,
                                "menu_id": ref.documentID,
                                "isOpened": false
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document added with ID: \(ref.documentID)")
                                }
                            }
                            
                            
                        }
                    } )
                    
                    alert.addTextField{(alertTextField) in
                        alertTextField.placeholder = "Write your new item here"
                        textField = alertTextField
                    }
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    if document.get("family_id") as! String == "" {
                        self.performSegue(withIdentifier: "goToSignIn", sender: self)
                    }
                   
                } else {
                    print("Document does not exist")
                }
            }
            
        // kalo belom login
        } else {
            performSegue(withIdentifier: "goToSignIn", sender: self)
        }
    }
    
    
    @IBAction func finishedEatingButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Is there any leftover from the meals in the family? ", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "No", style: .default, handler: { (action) in
            let leftOverRec = self.db.collection("leftover").document("\(self.family_id)_\(Date().timeIntervalSince1970)")
            
            leftOverRec.setData([
                "family_id": "\(self.family_id)",
                "date": Date().timeIntervalSince1970,
                "note": "",
                "leftOver" : false
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(leftOverRec.documentID)")
                    self.isLeftFood = false
                    self.performSegue(withIdentifier: "gotoAfterVote", sender: self)
                }
            }
            
        } )
        
        let action1 = UIAlertAction(title: "Yes", style: .cancel , handler: { (action) in
            
            if textField.text != "" {
                let leftOverRec = self.db.collection("leftover").document("\(self.family_id)_\(Date().timeIntervalSince1970)")
                
                leftOverRec.setData([
                    "family_id": "\(self.family_id)",
                    "date": Date().timeIntervalSince1970,
                    "note": "\(textField.text ?? "" )",
                    "leftOver" : true
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(leftOverRec.documentID)")
                        self.isLeftFood = true
                        self.performSegue(withIdentifier: "gotoAfterVote", sender: self)
                    }
                }
            }

            if textField.text == "" {
                let alert = UIAlertController(title: "Please fill out why did you leave the food?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        } )
        
        alert.view.tintColor = UIColor(named: "BrandOrange")
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Why did you leave the food?"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(action1)
        
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "goToSignIn" {
              guard segue.destination is SignInViewController else { return }
          }
        
        if segue.identifier == "gotoAfterVote" {
            guard let vc = segue.destination as? AfterVoteViewController else { return }
            vc.isLeftFood = self.isLeftFood
        }
        
        
      }
}






//Nanti ini didelete aja, cuma buat dummy data
struct Food {
    var isOpened: Bool
    let foodName: String
    let voters: [Vote]
}

struct Vote {
    let voter: String
    let choice: String
}

class DataSeeder {
    static let sharedData = [
        Food(isOpened: false, foodName: "Sapi Lada Hitam", voters: [
            Vote(voter: "Mom", choice: "Yes"),
            Vote(voter: "Dad", choice: "No"),
            Vote(voter: "Sis", choice: "No"),
            Vote(voter: "Bro", choice: "-")
    ]),
        Food(isOpened: false, foodName: "Sapi Lada Hitam 2", voters: [
            Vote(voter: "Mom", choice: "Yes")
    ])]
}
