//
//  MenuViewController.swift
//  Meal
//
//  Created by Nabil Rei on 08/06/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MenuViewController: UIViewController {
    
    var menu: [Menu] = []
    
    var db: Firestore!

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    var family_id: String?
    @IBOutlet weak var family_idLabel: UILabel!
    var menuArray: Array<Any>?
    @IBOutlet weak var addMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()

        
        print(family_id!)
        loadMenu()
        
        family_idLabel.text = family_id
        // Do any additional setup after loading the view.
    }
    
    //MARK: - LIKE BUTTON
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - DISLIKE BUTTON
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
    }
    
    
    func loadMenu() {
        
        let menuRef = db.collection("menu").document()
        
        db.collection("menu").order(by: "date", descending: true).whereField("family_id", isEqualTo: "\(self.family_id!)")
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
                
               
                print("document ID : \(menuRef.documentID)")
                print("query snapshot : \(querySnapshot?.documents)")
                
                if name != nil || name[0] as! String != "" {
                    for i in 0..<name.count {
                        self.menu.append(Menu(menu_id: menu_id[i] as! String, name: name[i] as! String, family_id: family_id[i] as! String, portions: portions[i] as! Int))
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
            }
    }
    
    @IBAction func addmenuPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add item", style: .default, handler: { (action) in
            
            print(textField.text)
            if textField.text != "" {
                
                // Add a new document with a generated id.
                var ref = self.db.collection("menu").document()
                
                ref.setData([
                    "name": "\(textField.text!)",
                    "family_id": "\(self.family_id!)",
                    "portions": 0,
                    "date": Date().timeIntervalSince1970,
                    "menu_id": ref.documentID
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
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Extension
extension MenuViewController: UITableViewDelegate{
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = self.menu[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel!.text = menu.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //MARK: - LIKE
        let like = UIContextualAction(style: .normal, title: "Like") { [weak self] (action, view, completionHandler) in
            print(self?.family_id)
            print("menu ID : \(self!.menu[indexPath.row].menu_id)")
            
            var likeRef = self?.db.collection("like").document("\(Auth.auth().currentUser!.uid)_\(self!.menu[indexPath.row].menu_id)")
            
            self?.db.collection("dislike").document("\(Auth.auth().currentUser!.uid)_\(self!.menu[indexPath.row].menu_id)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }

            likeRef?.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    /// DELETE DATA KALO DATANYA UDH ADA DI LIKE (unlike)
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self?.db.collection("like").document("\(Auth.auth().currentUser!.uid)_\(self!.menu[indexPath.row].menu_id)").delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                } else {
                    
                    /// KALO DATANYA GAADA DI LIKE, LIKE
                    likeRef?.setData([
                        "like_id": "\(likeRef?.documentID)",
                        "user_id": "\(Auth.auth().currentUser!.uid)",
                        "menu_id": "\(self!.menu[indexPath.row].menu_id)"
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
                        
            completionHandler(true)
        }
        
        //MARK: - DISLIKE
        
        let dislike = UIContextualAction(style: .normal, title: "Dislike") { [weak self] (action, view, completionHandler) in
            print(self?.family_id)
            print("menu ID : \(self!.menu[indexPath.row].menu_id)")
            
            var dislikeRef = self?.db.collection("dislike").document("\(Auth.auth().currentUser!.uid)_\(self!.menu[indexPath.row].menu_id)")
            
            self?.db.collection("like").document("\(Auth.auth().currentUser!.uid)_\(self!.menu[indexPath.row].menu_id)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            
            dislikeRef?.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    /// DELETE DATA KALO DATANYA UDH ADA DI DILIKE (undilike)
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self?.db.collection("dislike").document("\(Auth.auth().currentUser!.uid)_\(self!.menu[indexPath.row].menu_id)").delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                } else {
                    
                    /// KALO DATANYA GAADA DI LIKE, LIKE
                    dislikeRef?.setData([
                        "dislike_id": "\(dislikeRef?.documentID)",
                        "user_id": "\(Auth.auth().currentUser!.uid)",
                        "menu_id": "\(self!.menu[indexPath.row].menu_id)"
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
            
            completionHandler(true)
        }
        like.backgroundColor = .green
        dislike.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [like, dislike])
    }
    
    
    
}
