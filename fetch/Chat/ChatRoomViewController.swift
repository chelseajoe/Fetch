//
//  ChatRoomViewController.swift
//  fetch
//
//  Created by Anh Vu on 4/21/23.
//

import UIKit
import ParseSwift

class ChatRoomViewController: UIViewController {
    // MARK: States
    var chatMessages: [ChatMessage] = []
    var usernames: [String?] = []
    var chatRoom: ChatRoom? = nil
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgInputTextField: UITextField!
    
    // MARK: Actions
    @IBAction func didTapSendMessage(_ sender: Any) {
        guard let user = User.current else {
            print("Cannot get current user")
            return
        }
        
        // Add message to current messages
        var newMsg: ChatMessage = ChatMessage()
        newMsg.message = msgInputTextField.text
        newMsg.user = user.username
        chatMessages.append(newMsg)
        
        // Clear text field
        msgInputTextField.text = ""
        
        // Update in back-end
        let constraint = containsAll(key: "users", array: usernames)
        let query = ChatRoom.query(constraint)
        query.find { [weak self] result in
            switch result {
            case .success(let chatRooms):
                // TODO: CHECK FOR FOUND CHATROOMS HERE
                var room = chatRooms[0] // There's only 1 unique chat
                room.messages = self?.chatMessages
                room.save { [weak self] res in
                    switch res {
                    case .success(let updatedChatRoom):
                        // Update messages
                        self?.chatMessages = updatedChatRoom.messages!
                        
                        // Update UI
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        // UI Candy
        self.navigationController?.navigationBar.tintColor = .black

        // Handle keyboard show/hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Tap to hide keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Not interfere and cancel other interactions
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

    }
    
    // Move view when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    // Move view back when keyboard disappears
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Hide keyboard upon tap
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}

extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(chatMessages.count)
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let chatMessage = chatMessages[indexPath.row]
        cell.configure(with: chatMessage)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90.0
//    }
}
