//
//  AfterVoteViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 25/06/22.
//

import UIKit
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

class AfterVoteViewController: UIViewController {
    
    var isLeftFood: Bool?

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let left = "Encouragement"
    let notLeft = "Appreciation"
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        if !isLeftFood! {
            image.loadGif(name: notLeft)
            label.text = "Woah, cool!\nThank you for finishing all the food. It helps in reducing food waste."
        } else {
            image.loadGif(name: left)
            label.text = "Uh, no! You have wasted the food. Try to finish & less the portion of the food for the next time!"
        }
    }
    
    
    @IBAction func okButtonPressed(_ sender: Any) {
        db.collection("menu").whereField("family_id", isEqualTo: UserDefaults.standard.string(forKey: "family_id") ?? "" ).getDocuments() { (querySnapshot, err) in
          if let err = err {
            print("Error getting documents: \(err)")
          } else {
            for document in querySnapshot!.documents {
              document.reference.delete()
            }
          }
        }
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
