//
//  ChatRoomCell.swift
//  fetch
//
//  Created by Anh Vu on 4/22/23.
//

import UIKit
import ParseSwift

class ChatRoomCell: UITableViewCell {
    // MARK: States
    
    // MARK: Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userPicImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(with chatRoom: ChatRoom) {
        guard let myUser = User.current else {
            print("Cannot get current user for chat room.")
            return
        }
        
        // The other user
        let otherUsername = chatRoom.users!.filter { username in
            username != myUser.username
        }.first
        
        // Update UI
        usernameLabel.text = otherUsername
        userPicImageView.image = UIImage(systemName: "person.circle")
    }
}
