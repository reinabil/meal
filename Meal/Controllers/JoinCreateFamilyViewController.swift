//
//  JoinCreateFamilyViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 18/06/22.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

class JoinCreateFamilyViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var db: Firestore!

    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
    }
    
    // Cancel button navigation bar
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Join Family Group button pressed
    @IBAction func joinFamilyButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Input your family group ID", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Join", style: .default, handler: { (action) in
            
            print(textField.text)
            if textField.text != "" {
                
                // Add a new document with a generated id.
//                var ref = self.db.collection("menu").document()
//
//                ref.setData([
//                    "name": "\(textField.text!)",
//                    "family_id": "\(self.family_id!)",
//                    "portions": 0,
//                    "date": Date().timeIntervalSince1970,
//                    "menu_id": ref.documentID
//                ]) { err in
//                    if let err = err {
//                        print("Error adding document: \(err)")
//                    } else {
//                        print("Document added with ID: \(ref.documentID)")
//                    }
//                }
                
                
            }
        } )
        
        let action1 = UIAlertAction(title: "Cancel", style: .cancel , handler: { (action) in
            
            print(textField.text)
            if textField.text != "" {
                
                // Add a new document with a generated id.
//                var ref = self.db.collection("menu").document()
//
//                ref.setData([
//                    "name": "\(textField.text!)",
//                    "family_id": "\(self.family_id!)",
//                    "portions": 0,
//                    "date": Date().timeIntervalSince1970,
//                    "menu_id": ref.documentID
//                ]) { err in
//                    if let err = err {
//                        print("Error adding document: \(err)")
//                    } else {
//                        print("Document added with ID: \(ref.documentID)")
//                    }
//                }
                
                
            }
        } )
        
        alert.view.tintColor = UIColor(named: "BrandOrange")
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "n4b1l"
            textField = alertTextField
        }
        
        
        
        alert.addAction(action)
        alert.addAction(action1)
        
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
        
        
//        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Create New Family Group button pressed
    @IBAction func createNewFamilyButtonPressed(_ sender: UIButton) {
        
    }
}
