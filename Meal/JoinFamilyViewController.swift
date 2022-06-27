//
//  JoinFamilyViewController.swift
//  Meal
//
//  Created by Nabil Rei on 08/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class JoinFamilyViewController: UIViewController {
    
    var db: Firestore!
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var familyId: UITextField!
    @IBOutlet weak var joinFamily: UIButton!
    @IBOutlet weak var createFamily: UIButton!
    
    var family_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()

        let docRef = db.collection("user").document("\(Auth.auth().currentUser!.uid)")
//        let docRef = db.collection("user").document("r3LF7aqEu9ZXJoOgnvWlixFd8083")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.get("username") ?? "nil"
                print("Document data: \(dataDescription)")
                self.userName.text = dataDescription as? String
            } else {
                print("Document does not exist")
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func joinFamilyPressed(_ sender: UIButton) {
        if familyId.text != "" {
            family_id = familyId.text?.lowercased()
            
            db.collection("user").document("\(Auth.auth().currentUser!.uid)").updateData([
                "family_id" : family_id ?? ""
            ])
            
            self.performSegue(withIdentifier: "goToMenu", sender: self)
        }
        print(family_id!)
    }
    @IBAction func createFamilyPressed(_ sender: UIButton) {
        
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
            
        db.collection("user").document("\(Auth.auth().currentUser!.uid)").updateData([
            "family_id" : family_id ?? ""
        ])
        
        
        self.performSegue(withIdentifier: "goToMenu", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "goToMenu" {
              guard let vc = segue.destination as? MenuViewController else { return }
              vc.family_id = self.family_id
          }
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
