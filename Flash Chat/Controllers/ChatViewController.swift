//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        //        Message(sender: "1@2.com", body: "Hey"),
        //        Message(sender: "a@b.com", body: "Hello"),
        //        Message(sender: "1@2.com", body: "What's up")
    ]
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapShot, error) in
                //closure starts
                self.messages = []  //as putting this line inside of the closure, it is able to show new data only
                if error != nil {
                    print("there was an issue while we loading the data from firestore")
                } else {
                    if let snapshotDocuments = querySnapShot?.documents {
                        for i in snapshotDocuments {
                            let data = i.data() //data = key-value pair
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {   //as? works for downcasting
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                
                                DispatchQueue.main.async {  //manipulate the user interface
                                    self.tableView.reloadData()  //reload the data to the tableview
                                    //scroll to the last message
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self //triger the delegate
        //tableView.delegate = self //if the tableview interacted by user,
        
        navigationItem.hidesBackButton = true   //to hide back button
        //navigationItem.title = "Chat with me :)" //to write something on the navigation bar
        title = K.appName
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            //both are optional string
            //if both are not nil
            //add the new message data to the firebase
            db.collection(K.FStore.collectionName).addDocument(data:
                                                                [K.FStore.senderField: messageSender,
                                                                 K.FStore.bodyField: messageBody,
                                                                 K.FStore.dateField: Date().timeIntervalSince1970
                                                                ]) { (error) in
                if let e = error {
                    print(e)
                    print("there was an error while saving the data on firestore")
                } else {
                    print("successfully saved data")
                    DispatchQueue.main.async {
                        //textfiend will empty out??? why??
                        self.messageTextfield.text = ""
                    }
                }
            }
            
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            //going back to the first pagee of the app
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
}

//brings the data of messages on the tableview
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(messages.count)
        return messages.count    //the number of cells in the view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        
        //message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            //message from another user
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        //message[indexPath.row].body
        return cell
    }
    
    
}

/*
 //when the cell is clicked --interaction between cells
 extension ChatViewController: UITableViewDelegate {
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 print(indexPath.row)
 }
 }
 */
