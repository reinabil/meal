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
import CloudKit

class JoinCreateFamilyViewController: UIViewController {
    
    var family_id: String?
    
    let defaults = UserDefaults.standard
    var db: Firestore!

    override func viewDidLoad() {
        
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
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
           
            if textField.text != "" {
                let docFamilyRec = self.db.collection("family").document("\(textField.text!)")
                docFamilyRec.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                      
                            self.family_id = textField.text!.lowercased()
                            // nyimpen family_id di user default biar ga ilang2
                            UserDefaults.standard.set("\(textField.text!.lowercased())", forKey: "family_id")
                        
                            self.db.collection("user").document("\(Auth.auth().currentUser!.uid)").updateData([
                                "family_id" : self.family_id ?? ""
                            ])
                        
                            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                       
                    } else {
                        
                        // family id ga ada
                        print("Document does not exist")
                        let alert = UIAlertController(title: "Family ID tidak ada", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }

            if textField.text == "" {
                let alert = UIAlertController(title: "Family ID Masih kosong", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } )
        
        let action1 = UIAlertAction(title: "Cancel", style: .cancel , handler: { (action) in
        } )
        
        alert.view.tintColor = UIColor(named: "BrandOrange")
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "f000d"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(action1)
        
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Create new family id
    // Create New Family Group button pressed
    @IBAction func createNewFamilyButtonPressed(_ sender: UIButton) {
        
        family_id = randomString(length: 5)
        db.collection("family").document(family_id!).setData([
            "family_id": "\(family_id!)"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
            
        //MARK: - remove comment
        db.collection("user").document("\(Auth.auth().currentUser!.uid)").updateData([
            "family_id" : family_id ?? ""
        ])
        
        UserDefaults.standard.set("\(family_id ?? "".lowercased())", forKey: "family_id")
        
        // alert
        let alert = UIAlertController(title: "Your Family Group ID \"\(family_id ?? "")\"", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Share", style: .default, handler: { (action) in
            //Set the default sharing message.
            let message = """
                Let's join to our Famealy group:
                \(self.family_id ?? "")

                🌭🍞🍕🍗🍱🥪
                Famealy.
                Vote more, waste less.
                """
            let objectsToShare = [message]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        } )
        
        let action1 = UIAlertAction(title: "Join", style: .cancel , handler: { (action) in
        } )
        
        alert.view.tintColor = UIColor(named: "BrandOrange")
        
        alert.addAction(action)
        alert.addAction(action1)
        
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
        
    }
}
