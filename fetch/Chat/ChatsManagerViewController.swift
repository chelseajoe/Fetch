//
//  ChatViewController.swift
//  fetch
//
//  Created by Anh Vu on 4/18/23.
//

import UIKit
import ParseSwift
import NotificationCenter

class ChatsManagerController: UIViewController {
    // States
    var chatRooms: [ChatRoom] = []
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView data
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        fetchChatRooms()
        
        // UI Candy
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func fetchChatRooms() {
        // Fetch chat messages
        guard let user = User.current,
        let username = user.username else {
            print("Cannot get current user")
            return
        }
        
        let constraint: QueryConstraint = containedIn(key: "users", array: [username])
        
        // Sort chat rooms by lastUpdated date
        let query = ChatRoom.query(constraint)
            .includeAll()
            .order([.ascending("lastUpdated")])
        query.find { [weak self] result in
            switch result {
            case .success(let chatRooms):
                self?.chatRooms = chatRooms
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Prepare segue to send users info to ChatRoomViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatSegue",
           let chatRoomCell = sender as? ChatRoomCell,
           let cellRow = tableView.indexPath(for: chatRoomCell)?.row,
           let chatRoomViewController = segue.destination as? ChatRoomViewController {
            
            // Set chatRoom in destination ChatRoomViewController
            let chatRoom = chatRooms[cellRow]
            chatRoomViewController.chatMessages = chatRoom.messages!
            chatRoomViewController.usernames = chatRoom.users!
            chatRoomViewController.chatRoom = chatRoom
        }
    }
}

extension ChatsManagerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as! ChatRoomCell
        let chatRoom = chatRooms[indexPath.row]
        cell.configure(with: chatRoom)
        return cell
    }

}
