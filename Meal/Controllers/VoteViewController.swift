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
    @IBOutlet weak var addButton: UIButton!
    var menuArray: Array<Any>?
    var menu: [Menu] = []
    
    //Dummy data, change with real data later
    var tableViewData = DataSeeder.sharedData
    //Variable to store expanded tableViewCell data
    var openedCellSections: [IndexPath] = []
    var openedCellDataIndex: [Int] = []
    
    let defaults = UserDefaults.standard
    var db: Firestore!
    var family_id = ""
    
    override func viewDidLoad() {
        
        print("\(UserDefaults.standard.string(forKey: "family_id"))")
        
        if UserDefaults.standard.string(forKey: "family_id") != nil || UserDefaults.standard.string(forKey: "family_id") != "" {
            family_id = UserDefaults.standard.string(forKey: "family_id") ?? ""
        }
        
        print(Auth.auth().currentUser?.email)
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
        
        if UserDefaults.standard.string(forKey: "family_id") == nil || UserDefaults.standard.string(forKey: "family_id") == "" {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            loadMenu()
        }
        
        
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
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        
        
    print(UserDefaults.standard.bool(forKey: "usersignedin"))
        print(Auth.auth().currentUser?.email)
    
        
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
                    print("\(document.get("family_id"))")
                    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
                    var textField = UITextField()
                    
                    let action = UIAlertAction(title: "Add item", style: .default, handler: { (action) in
                        
                        print(textField.text)
                        if textField.text != "" {
                            
                            // Add a new document with a generated id.
                            var ref = self.db.collection("menu").document()
                            
                            ref.setData([
                                "name": "\(textField.text!)",
                                "family_id": "\(self.family_id)",
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
        
    }
    
    func loadMenu() {
        
        let menuRef = db.collection("menu").document()
        
        db.collection("menu").order(by: "date", descending: true).whereField("family_id", isEqualTo: "\(UserDefaults.standard.string(forKey: "family_id")!)")
            .addSnapshotListener { querySnapshot, error in
                self.menu = []
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                let name = documents.map { $0["name"] ?? [""] }
                let family_id = documents.map { $0["family_id"] ?? [0] }
                let portions = documents.map { $0["portions"] ?? [""] }
                let menu_id = documents.map { $0["menu_id"] ?? [""]}
                let isOpened = documents.map { $0["isOpened"] ?? [""]}
                
               
                print("document ID : \(menuRef.documentID)")
                print("query snapshot : \(querySnapshot?.documents)")
                
                if name != nil || name[0] as! String != "" {
                    for i in 0..<name.count {
                        self.menu.append(Menu(menu_id: menu_id[i] as! String, name: name[i] as! String, family_id: family_id[i] as! String, portions: portions[i] as! Int, isOpened: isOpened[i] as! Bool))
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: self.menu.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
                    
                
                
                print("Menu: \(name)")
//                print("Document ID: \()")
                print("Portions: \(portions)")
                print("Family ID: \(family_id)")
                print(self.menu)
                
                
                print("jumlah menu : \(self.menu.count)")
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "goToSignIn" {
              guard let vc = segue.destination as? SignInViewController else { return }
          }
      }
}


extension VoteViewController: UITableViewDelegate, UITableViewDataSource, TopPartTableViewCellDelegate {
    
    func buttonClicked(cell: TopPartTableViewCell) {
        //Insert logic when eat/dont eat button pressed
        print("button pressed")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("idx path: \(indexPath) - row: \(indexPath.row)")
//        let menu = self.menu[indexPath.row]
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "topCell") as? TopPartTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            // Set foodName, portion, and button state here (Example code below)
            //
            cell.foodNameLabel.text = "foodName 1"
            //cell.portionLabel.text = "Portion: xx"
            //cell.eatButton or cell.dontEatButton

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell") as? BottomPartTableViewCell else { return UITableViewCell() }
            
            // Set voter's name and icon in BottomPartTableViewCell.swift
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row == 0) ? true : false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count //change with real data later
//        return self.menu.count ?? 0
    }
    
    //Function for showing delete button when the card is swiped
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            //Change code below to delete item logic
            print("item at \(indexPath.section) deleted")
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Function to expand/collapse card when clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menu[indexPath.section].isOpened {
            menu[indexPath.section].isOpened = false
            
            if let savedIndexPath = openedCellSections.firstIndex(of: indexPath) {
                openedCellSections.remove(at: savedIndexPath)
                openedCellDataIndex.remove(at: savedIndexPath)
            }
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            let topPartCell = tableView.cellForRow(at: indexPath) as? TopPartTableViewCell
            topPartCell?.arrowImage.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal)
        } else {
            menu[indexPath.section].isOpened = true
            
            openedCellSections.append(indexPath)
            openedCellDataIndex.append(indexPath.section)
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            let topPartCell = tableView.cellForRow(at: indexPath) as? TopPartTableViewCell
            topPartCell?.arrowImage.image = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.menu.count ?? 0
        
//        return 3

        if menu[section].isOpened {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        } else {
            return 150
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
