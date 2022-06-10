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
    
    func loadMenu() {
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
                
                if name != nil || name[0] as! String != "" {
                    for i in 0..<name.count {
                        self.menu.append(Menu(name: name[i] as! String, family_id: family_id[i] as! String, portions: portions[i] as! Int))
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
                var ref: DocumentReference? = nil
                ref = self.db.collection("menu").addDocument(data: [
                    "name": "\(textField.text!)",
                    "family_id": "\(self.family_id!)",
                    "portions": 0,
                    "date": Date().timeIntervalSince1970
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        let action = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            print(self?.family_id)
            completionHandler(true)
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
