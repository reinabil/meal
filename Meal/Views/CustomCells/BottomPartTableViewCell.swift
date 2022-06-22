//
//  BottomPartTableViewCell.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 15/06/22.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

class BottomPartTableViewCell: UITableViewCell {

    
    let defaults = UserDefaults.standard
    var db: Firestore!
    var menuArray: Array<Any>?
    var like: [Like] = []
    var menu: [Menu] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    
        
        //Register custom collectionView cell XIB to collectionView
        collectionView.register(UINib(nibName: "VoterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "voterCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

extension BottomPartTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Number of collectionView cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return 2 //change to number of real voters
    }
    
    //Set cell for item at indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "voterCell", for: indexPath) as? VoterCollectionViewCell
        
        // Set voter's name and icon here. (Example code below)
        //
        //cell?.cellLabel = "voter's name"
        //cell?.cellImage = UIImage(systemName: "voter's icon")
        //cell?.cellBackground = UIColor()
        
        return cell ?? UICollectionViewCell()
    }
    
    //Set size of item at indexPath
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 64)
    }
}
