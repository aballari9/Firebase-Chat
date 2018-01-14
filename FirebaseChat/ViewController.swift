//
//  ViewController.swift
//  HackGTeenyChatApp
//
//  Created by Brian Wang on 9/13/17.
//  Copyright © 2017 BW. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct Message {
    let message: String
    let author: String
    //let timnestamp: Date
}

class ViewController: UIViewController {
    
    // reference to the firebase database
    var root: DatabaseReference!
    
    // backing messages array for tableView
    var messages:[Message] = []

    // connections to UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the root firebase reference
        root = Database.database().reference()

        // start observing all messages
        observeMessages()
    }
    
    func observeMessages() {
        //YOUR CODE HERE
//        root.child("chat").observe(.value) { (snapshot) in
//            if let messages = snapshot.value as? [String:String] {
//                self.messages = Array(messages.values)
//                self.tableView.reloadData()
//
//            }
//
//        }
        
//        root.child("chat").observe(.childAdded) { (snapshot) in
//            if let message = snapshot.value as? String {
//                self.messages.insert((message), at: 0)
//                self.tableView.reloadData()
//            }
//
//        }
        
        root.child("chats").observe(.childAdded) { (snapshot) in
            if let messageDict = snapshot.value as? [String:String],
                let message = messageDict["message"],
                let author = messageDict["author"]
            {
                    let m = Message(message: message, author: author)
                    self.messages.insert(m, at: 0)
                    self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        //YOUR CODE HERE
        let newReference = root.child("chats").childByAutoId()
        newReference.setValue([
            "message" : messageTextField.text!,
            "author" : "Akhila"
        ])
        
    }
}

// this is an extension, it allows you to write additional methods and variables to a preexisting class.
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // this delegate method tells the tableview how many rows it has.
    // in this case, we want the tableview to have the same number of rows as there are messages.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    // this delegate method tells the tableview what content goes into each row.
    // this is called messages.count number of times, one for each message
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue the protoype cell from main.storyboard and assign it to 'cell'
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        // set the label to the message indexed from messages
        let m = messages[indexPath.row]
        cell.textLabel?.text = m.message
        cell.detailTextLabel?.text = m.author
        
        // give the cell to tableview to display
        return cell
    }
}

