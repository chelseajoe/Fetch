//
//  ChatMessageCell.swift
//  fetch
//
//  Created by Anh Vu on 4/18/23.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    // MARK: Outlet - Just message
    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var messageStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with chatMessage: ChatMessage) {
        // Data
        messageLabel.text = chatMessage.message
        
        // UI
        guard let user = User.current else {
            print("Cannot get current user")
            return
        }
        
        // Place message based on who sent it
        if chatMessage.user == user.username {
            messageLabel.textAlignment = .right
        } else {
            messageLabel.textAlignment = .left
        }
    }

}
