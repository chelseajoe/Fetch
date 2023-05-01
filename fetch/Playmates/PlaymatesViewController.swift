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
    private var currentUserIndex = 0
    
    
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
            let currentUser = self.users[currentUserIndex]
            
            // Update UI
            DispatchQueue.main.async {
                // Update UI elements with the retrieved data
                if (currentUser.age != nil) {
                    self.nameAgeLabel.text = currentUser.name! + ", " + String(currentUser.age!)
                } else {
                    self.nameAgeLabel.text = currentUser.name!
                }
               
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
        } else {
            // Present alert
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Oops!", message: "No more active users in your area.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Check back later", style: .cancel) { _ in
                    self.nameAgeLabel.text = "(no more active users in your area)"
                }
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
                
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
    @objc func expandProfile(_ sender: Any) {
        performSegue(withIdentifier: "expandProfileSegue", sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "expandProfileSegue",
           
            let detailViewController = segue.destination as? PlaymatesDetailViewController {
            
            // Setup the detailView
            let user = users[currentUserIndex]
            detailViewController.user = user
            
        }
    }
    @objc func like() {
        if users.count > 0, var currentUser = User.current,
           (users[currentUserIndex].username != nil) {
            if currentUser.likedUsers == nil {
                currentUser.likedUsers = []
            }
            currentUser.likedUsers?.append(users[currentUserIndex].username!)
            
            currentUser.save { [weak self] result in // [weak self]
                switch result {
                case .success(_):
                    self?.checkMatch(liked: true)
                    
                case .failure(let error):
                    print("ERROR!!")
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    @objc func nope() {
        if users.count > 0, var currentUser = User.current,
           (users[currentUserIndex].username != nil) {
            if currentUser.dislikedUsers == nil {
                currentUser.dislikedUsers = []
            }
            currentUser.dislikedUsers?.append(users[currentUserIndex].username!)
            
            currentUser.save { [weak self] result in // [weak self]
                switch result {
                case .success(_):
                    self?.checkMatch(liked: false)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    func checkMatch(liked: Bool) {
        // Check if there's a mutual like
        var otherUser = users[currentUserIndex]
        
        if liked, var currentUser = User.current,
           ((otherUser.likedUsers?.contains(currentUser.username!)) != nil){
            // Update the users
            
            if currentUser.matchedUsers == nil {
                currentUser.matchedUsers = []
            }
            if otherUser.matchedUsers == nil {
                otherUser.matchedUsers = []
            }
            currentUser.matchedUsers?.append(otherUser.username!)
            otherUser.matchedUsers?.append(currentUser.username!)
            
            currentUser.save { [weak self] result in
                otherUser.save { [weak self] result in
                    
                    // Create the ChatRoom
                    var room = ChatRoom()
                    room.users = [otherUser.username!, currentUser.username!]
                    room.lastUpdated = Date()
                    
                    room.save { [weak self] result in // [weak self]
                        switch result {
                        case .success(_):
                            self?
                                .showMatchAlert()
                            
                        case .failure(let error):
                            print("OMG", error.localizedDescription)
                        }
                        
                    }
                }
            }
            
          
        } else {
            self.users.removeFirst()
            self.selectPlaymate()
        }
        
    }
    
    func showMatchAlert() {
        // Present alert
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "It's a match!", message: "You both liked each other", preferredStyle: .alert)
            let chatAction = UIAlertAction(title: "Chat Now", style: .default) { _ in
                // segue to chat
                self.performSegue(withIdentifier: "matchSegue", sender: nil)
                self.users.removeFirst()
                self.selectPlaymate()
            }
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { _ in
                self.users.removeFirst()
                self.selectPlaymate()
            }
            
            alertController.addAction(chatAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
        }
    }
    
}
