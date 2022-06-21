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
    
    //Dummy data, change with real data later
    var tableViewData = DataSeeder.sharedData
    //Variable to store expanded tableViewCell data
    var openedCellSections: [IndexPath] = []
    var openedCellDataIndex: [Int] = []
    
    let defaults = UserDefaults.standard
    var db: Firestore!
    
    override func viewDidLoad() {
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
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        //Check if there is any cell that is expanded
        if openedCellSections.count > 0 {
            //Set each element's isOpened property to false (collapse it)
            for i in 0...openedCellSections.count-1 {
                tableViewData[openedCellDataIndex[i]].isOpened = false
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
        
        performSegue(withIdentifier: "goToSignIn", sender: self)
        
    }
    
    
    @IBAction func finishedEatingButtonPressed(_ sender: UIButton) {
        
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
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "topCell") as? TopPartTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            // Set foodName, portion, and button state here (Example code below)
            //
            //cell.foodNameLabel.text = "foodName"
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
        return tableViewData.count //change with real data later
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
        if tableViewData[indexPath.section].isOpened {
            tableViewData[indexPath.section].isOpened = false
            
            if let savedIndexPath = openedCellSections.firstIndex(of: indexPath) {
                openedCellSections.remove(at: savedIndexPath)
                openedCellDataIndex.remove(at: savedIndexPath)
            }
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            let topPartCell = tableView.cellForRow(at: indexPath) as? TopPartTableViewCell
            topPartCell?.arrowImage.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal)
        } else {
            tableViewData[indexPath.section].isOpened = true
            
            openedCellSections.append(indexPath)
            openedCellDataIndex.append(indexPath.section)
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            let topPartCell = tableView.cellForRow(at: indexPath) as? TopPartTableViewCell
            topPartCell?.arrowImage.image = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].isOpened {
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
