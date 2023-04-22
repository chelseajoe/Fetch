//
//  PlaymatesCell.swift
//  fetch
//
//  Created by Pei Qi Tea on 22/4/23.
//

import Foundation

import UIKit
 // Library to load images from URL

class PlaymatesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// Configures the cell's UI for the given movie.
    func configure(with user: User) {
        // Load image async via Nuke library image loading helper method
       
    }

}
