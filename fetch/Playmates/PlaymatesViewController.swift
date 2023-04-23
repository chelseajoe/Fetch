//
//  FeedViewController.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/1/22.
//

import UIKit

// TODO: P1 1 - Import Parse Swift
import ParseSwift

class PlaymatesViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()

    private var users = [User]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryPlaymates()
    }

    private func queryPlaymates(completion: (() -> Void)? = nil) {
        // MARK: Is there a good way to specify constraints for the fetch, or do we have to pull everything and then filter?
        // MARK: Maybe implement sorting profiles based on matching preferences
        // Back4App Query Codebook: Queries with constraints involving array type fields?
        let DEFAULT_MILE_DIAMETER: Double = 5
        
        guard let myUser = User.current else {
            print("Failed to get current user.")
            return
        }
        
        // TODO: Define constraints based on LOCATION. Probably hard code a "diameter" at first.
        guard let location = myUser.location,
              let geopoint = try? ParseGeoPoint(latitude: location.latitude,
                                                longitude: location.longitude) else {
            print("Failed to get current user's location")
            return
        }
       
        let constraint = withinKilometers(key: "location", geoPoint: geopoint, distance: DEFAULT_MILE_DIAMETER)
        let query = User.query(constraint).where(  "username" != myUser.username).include("user")

        query.find { [weak self] result in // [weak self]
            switch result {
            case .success(let users):
                self?.users = users
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }


    }

    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        queryPlaymates { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "PlaymatesCell", for: indexPath) as! PlaymatesCell

        // Get the movie that corresponds to the table view row
        

        // Configure the cell with it's associated movie
        //cell.configure(with: movie)

        // return the cell for display in the table view
        return cell
    }
    
}
