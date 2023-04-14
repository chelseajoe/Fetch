//
//  ProfileViewController.swift
//  fetch
//
//  Created by Chelsea Joe on 4/13/23.
//

import UIKit
import ParseSwift


class ProfileViewController: UIViewController {
//    var user: User!
    
    // Define the query
    @IBOutlet weak var profileImageView: UIImageView!
//    let query = Query<User>()
    @IBOutlet weak var smallImageLeftView: UIImageView!
    
    @IBOutlet weak var smallImageMiddleView: UIImageView!
    
    @IBOutlet weak var smallImageRightView: UIImageView!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var breedTextView: UITextView!
    
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var nameAndAgeLabel: UILabel!

    @IBOutlet weak var preferencesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load profile
        getMyProfile { name, breed, age, bio, preferences, images in
            // Update UI or perform any other action with the retrieved data
            DispatchQueue.main.async {
                // Update UI elements with the retrieved data
                self.nameAndAgeLabel.text = "\(name), \(age)"
                self.breedTextView.text = breed
                self.descriptionTextView.text = bio
                self.preferencesTextView.text = preferences?.joined(separator: ", ")
                // Handle images using ParseSwift's file handling methods
                if let data = images?.first?.data {
                    if let image = UIImage(data: data) {
                        // Use the image object for further processing or display in UIImageView
                        self.profileImageView.image = image
                    } else {
                        print("Error converting data to UIImage")
                    }
                } else {
                    print("No data found")
                }
                
                
                // e.g. self.imageView.file = images?.first
            }
        }
//        profileImageView = user.images[0]
//        smallImageLeftView = user.images[1]
//        smallImageMiddleView = user.images[2]
//        smallImageRightView = user.images[3]
        

        // Do any additional setup after loading the view.
    }

//    func getMyProfile() {
//        guard let myUser = User.current else {
//            print("Failed to get current user.")
//            return
//        }
//
//        let constraint = "username" == myUser.username
//        let query = User.query(constraint)
//
//        var imageArray: [UIImage] = []
//
//        query.find { result in
//            switch result {
//            case .success(let users):
//
//                // Retrieve paresefile images from the users in the query result
//                if let parseFiles = users.first?.images {
//                    // convert parsefies to images
//                    for parseFile in parseFiles {
//                            parseFile.getDataInBackground() { result in
//                                switch result {
//                                case .success(let imageData):
//                                    if let image = UIImage(data: imageData) {
//                                        imageArray.append(image)
//                                    } else {
//                                        print("Failed to convert data to image")
//                                    }
//                                case .failure(let error):
//                                    print("Failed to download image: \(error)")
//                                }
//                            }
//                        }
//
//                    print("Images: \(parseFiles)")
//
//                }
//
//
//
//
//
//
////                // set profile image view to first image
////                profileImageView = imageArray[0]
////                smallImageLeftView = imageArray[1]
////                smallImageMiddleView = imageArray[2]
////                smallImageRightView = imageArray[3]
////
////
//                // text updates
//
////                // Set descriptionTextView text
////                if let bio = users.first?.bio {
////                    descriptionTextView.text = bio
////                }
////
////                // Set breed text
////                if let breed = users.first?.breed {
////                    breedTextView.text = breed
////                }
////
////                // Set breed text
////                if let location = users.first?.location {
////                    locationTextView.text = location.description
////                }
////
//
//
//
//
//            case .failure(let error):
//                print("Failed to get my user profile: \(error)")
//            }
//        }
//    }
//
//
//    func helloworld() {
//        guard let myUser = User.current else {
//            print("Failed to get current user.")
//            return
//        }
//
//        let constraint = "username" == myUser.username
//        let query = User.query(constraint)
//
//        var imageArray: [UIImage] = []
//
//        query.find { result in
//            switch result {
//            case .success(let users):
//
//                // Retrieve paresefile images from the users in the query result
//                if let parseFiles = users.first?.images {
//                    // convert parsefies to images
//                    for parseFile in parseFiles {
//                            parseFile.getData() { result in
//                                switch result {
//                                case .success(let imageData):
//                                    if let image = UIImage(data: imageData) {
//                                        imageArray.append(image)
//                                    } else {
//                                        print("Failed to convert data to image")
//                                    }
//                                case .failure(let error):
//                                    print("Failed to download image: \(error)")
//                                }
//                            }
//                        }
//
//                    print("Images: \(parseFiles)")
//
//                }
//
//
//
//
//
//
//
//
//            case .failure(let error):
//                print("Failed to get my user profile: \(error)")
//            }
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
