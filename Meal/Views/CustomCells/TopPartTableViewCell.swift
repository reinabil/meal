//
//  TopPartTableViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 15/06/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol TopPartTableViewCellDelegate:AnyObject {
    func buttonClicked(cell: TopPartTableViewCell)
    func eatButtonPressed(cell: TopPartTableViewCell, send: UIButton)
    func dontEatButtonPressed(cell: TopPartTableViewCell, send: UIButton)
}

class TopPartTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var dontEatButton: UIButton!
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    weak var delegate: (TopPartTableViewCellDelegate)?
    
//    let voteViewController: VoteViewController? = nil
    var db: Firestore!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        setupButton(button: eatButton)
        setupButton(button: dontEatButton)
        
        //Make background frame rounded
        background.layer.cornerRadius = 10
        background.backgroundColor = UIColor(named: "BrandLightGray")
        
        foodNameLabel.textColor = UIColor.black
        portionLabel.textColor = UIColor.black
        arrowImage.tintColor = UIColor.black
        
//        loadLike()
    }
    
    func setupButton(button: UIButton) {
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.black
        button.layer.cornerRadius = button.frame.height/2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 3
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.buttonClicked(cell: self)
    }
    
    @IBAction func eatButtonPressed(_ sender: UIButton) {
        delegate?.eatButtonPressed(cell: self, send: sender)
    }
    
    @IBAction func dontEatButtonPressed(_ sender: UIButton) {
        delegate?.dontEatButtonPressed(cell: self, send: sender)
    }
    
//    func loadLike() {
//
//        var family_id = UserDefaults.standard.bool(forKey: "family_id")
//        var user_id = Auth.auth().currentUser?.uid
//        let menuRef = db.collection("like").document()
//
//        print("user_id \(user_id!)")
//
//        db.collection("like").whereField("user_id", isEqualTo: "\(user_id!)")
//            .addSnapshotListener { querySnapshot, error in
//                self.like = []
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//
//                let like_id = documents.map { $0["like_id"] ?? [""] }
//                let menu_id = documents.map { $0["menu_id"] ?? [0] }
//                let user_id = documents.map { $0["user_id"] ?? [""] }
//
//
//                print("document ID : \(menuRef.documentID)")
//                print("query snapshot : \(querySnapshot?.documents)")
//
//                if like_id != nil || like_id[0] as! String != "" {
//                    for i in 0..<like_id.count {
//                        self.like.append(Like(like_id: like_id[i] as! String, menu_id: menu_id[i] as! String, user_id: user_id[i] as! String))
//                    }
//                }
//            }
//
//        print("LIKE DATABASE = \(like)")
//    }
}
