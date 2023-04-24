//
//  FeedViewController.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/1/22.
//

import UIKit

// TODO: P1 1 - Import Parse Swift
import ParseSwift
import Alamofire
import AlamofireImage

class PlaymatesViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var nopeButton: UIImageView!
    
    @IBOutlet weak var likeButton: UIImageView!
    
    @IBOutlet weak var moreInfoButton: UIImageView!
    
    private let refreshControl = UIRefreshControl()

    private var users = [User]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add gestures to the images
        let tapMoreInfo = UITapGestureRecognizer(target: self, action: #selector(self.expandProfile))
        moreInfoButton.addGestureRecognizer(tapMoreInfo)
        
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(self.like))
        likeButton.addGestureRecognizer(tapLike)
        
        let tapNope = UITapGestureRecognizer(target: self, action: #selector(self.nope))
        nopeButton.addGestureRecognizer(tapNope)
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
                self?.selectPlaymate()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }


    }
    
    private func selectPlaymate() {
        if !self.users.isEmpty {
            let currentUser = self.users.removeLast()
            print(self.users)
            
            // Update UI
            DispatchQueue.main.async {
                // Update UI elements with the retrieved data
                self.nameAgeLabel.text = currentUser.name
                self.breedLabel.text = currentUser.breed
                if let url = currentUser.images?.first?.url {
                    // Use AlamofireImage helper to fetch remote image from URL
                    let imageDataRequest = AF.request(url).responseImage { [weak self] response in
                        switch response.result {
                            case .success(let image):
                                // Set image view image with fetched image
                                self?.imageView.image = image
                            case .failure(let error):
                                print("❌ Error fetching image: \(error.localizedDescription)")
                                break
                        }
                    }
                    
                }
                
                // Handle images using ParseSwift's file handling methods
                if let data = currentUser.images?.first?.data {
                    if let image = UIImage(data: data) {
                        // Use the image object for further processing or display in UIImageView
                        self.imageView.image = image
                    } else {
                        print("Error converting data to UIImage")
                    }
                } else {
                    print("No data found")
                }

            }
        }
        
    }
    

    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        queryPlaymates { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    //    MARK: Actions
    @objc func expandProfile() {
            print("Expan profile using Segue")
        }
    @objc func like() {
            print("like the person send to backend")
        
        
        }
    @objc func nope() {
            print("nope the person send to tbackend")
        }

}
