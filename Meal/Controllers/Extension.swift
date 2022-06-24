//
//  Extension.swift
//  Meal
//
//  Created by Nabil Rei on 24/06/22.
//

import Foundation
import UIKit
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

extension VoteViewController: UITableViewDelegate, UITableViewDataSource, TopPartTableViewCellDelegate {
    
    func dontEatButtonPressed(cell: TopPartTableViewCell, send: UIButton) {
        
        print(send.tag)
        print(self.menu[send.tag].menu_id)
        
        print(self.family_id)
        print("menu ID : \(self.menu[send.tag].menu_id)")
        
        var dislikeRef = self.db.collection("dislike").document("\(Auth.auth().currentUser!.uid)_\(self.menu[send.tag].menu_id)")
        
        self.db.collection("like").document("\(Auth.auth().currentUser!.uid)_\(self.menu[send.tag].menu_id)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        dislikeRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                /// DELETE DATA KALO DATANYA UDH ADA DI DISLIKE (undislike)
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.db.collection("dislike").document("\(Auth.auth().currentUser!.uid)_\(self.menu[send.tag].menu_id)").delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        
                        //MARK: - bg color to default
                    }
                }
            } else {
                
                /// KALO DATANYA GAADA DI dislike, dislike
                dislikeRef.setData([
                    "dislike_id": "\(dislikeRef.documentID)",
                    "user_id": "\(Auth.auth().currentUser!.uid)",
                    "menu_id": "\(self.menu[send.tag].menu_id)"
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        
                        //MARK: - bg color to orange
                    }
                }
            }
        }
        
        
        if send.backgroundColor == UIColor.white {
            send.backgroundColor = UIColor(named: "BrandOrange")
            send.tintColor = UIColor.white
        } else {
            send.backgroundColor = UIColor.white
            send.tintColor = UIColor.black
        }
    }
    
    
    func eatButtonPressed(cell: TopPartTableViewCell, send: UIButton) {
        print(send.tag)
        print(self.menu[send.tag].menu_id)
        
        print(self.family_id)
        print("menu ID : \(self.menu[send.tag].menu_id)")
        
        var likeRef = self.db.collection("like").document("\(Auth.auth().currentUser!.uid)_\(self.menu[send.tag].menu_id)")
        
        // hanya menghapus like, kalo ada dislike
        self.db.collection("dislike").document("\(Auth.auth().currentUser!.uid)_\(self.menu[send.tag].menu_id)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

        likeRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                /// DELETE DATA KALO DATANYA UDH ADA DI LIKE (unlike)
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.db.collection("like").document("\(Auth.auth().currentUser!.uid)_\(self.menu[send.tag].menu_id)").delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            } else {
                
                /// KALO DATANYA GAADA DI LIKE, LIKE
                likeRef.setData([
                    "like_id": "\(likeRef.documentID)",
                    "user_id": "\(Auth.auth().currentUser!.uid)",
                    "menu_id": "\(self.menu[send.tag].menu_id)"
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
        }
        print("tag : \(send.tag)")
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
                    // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
                    return
                }
        
        let user_liked = like.contains(where: {$0.menu_id == menu[send.tag].menu_id}) && like.contains(where: {$0.user_id == Auth.auth().currentUser!.uid})
        
        if user_liked {
            send.backgroundColor = UIColor(named: "BrandOrange")
            send.tintColor = UIColor.white
        } else {
            send.backgroundColor = UIColor.white
            send.tintColor = UIColor.black
        }
        
        print("APAKAH LIKENYA LIKE MENU INI? \(like.contains(where: {$0.menu_id == menu[send.tag].menu_id}))")
        print("APAKAH ADA LIKE? \(like.contains(where: {$0.user_id == Auth.auth().currentUser?.uid ?? ""}))")
        print("EATTTTTTT")
        
    }
    
    func buttonClicked(cell: TopPartTableViewCell) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("idx path: \(indexPath) - row: \(indexPath.row)")
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "topCell") as? TopPartTableViewCell else { return UITableViewCell() }
            
            var portions = 0
            
            cell.delegate = self
            // Set foodName, portion, and button state here (Example code below)
            //
            cell.foodNameLabel.text = self.menu[indexPath.section].name
            cell.portionLabel.text = "Portion: \(portions)"
            
            cell.eatButton.tag = indexPath.section
            cell.dontEatButton.tag = indexPath.section
            
            

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
            print("item \(self.menu[indexPath.section].menu_id) deleted")
            
            self.db.collection("menu").document("\(self.menu[indexPath.section].menu_id)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            
            self.menu.remove(at: indexPath.section)
            print(self.menu)
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
            
            // dari nutup ke buka
            menu[indexPath.section].isOpened = true
            
            print("\(self.menu[indexPath.section].menu_id)")
            
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
