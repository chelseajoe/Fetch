//
//  User.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/29/22.
//

import Foundation
import ParseSwift
import CoreLocation
import UIKit

// A User also represents a Dog
struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    
    // Custom Properties for Fetch
    // -- Dog traits --
    var name: String?
    var breed: String?
    var age: Int?
    var bio: String?
    var preferences: [String]?
    var images: [ParseFile]?
    
    // -- User metadata --
    var location: ParseGeoPoint?
    var recentlyActive: Bool?
    
    // -- Cross-user data  --
    // Strings represent usernames
    var dislikedUsers: [String]?
    var likedUsers: [String]? // Users that self liked
    var usersLiked: [String]? // Users that liked self
    var matchedUsers: [String]?
}

//extension User {
//    static var mockUser: User(objectId: "id1",
//                              createdAt: Date?,
//                              updatedAt: Date?
                              
                              


// For display in My Profile view
// MARK: The current plan is NOT to fetch all parts of profile upon login.

func getMyProfile(completion: @escaping (String?, String?, Int?, String?, [String]?, [ParseFile]?) -> Void) {
    guard let myUser = User.current else {
        print("Failed to get current user.")
        return
    }
    
    let constraint = "username" == myUser.username
    let query = User.query(constraint)
    
    query.find { result in
        switch result {
        case .success(let users):
            guard let currentUser = users.first else {
                print("Current user not found.")
                return
            }
            // Access custom properties for own user
            let name = currentUser.name
            let breed = currentUser.breed
            let age = currentUser.age
            let bio = currentUser.bio
            let preferences = currentUser.preferences
            let images = currentUser.images
            
            // Call the completion block with the retrieved data
            completion(name, breed, age, bio, preferences, images)
            
        case .failure(let error):
            print("Error retrieving current user: \(error)")
        }
    }
}

//func getMyProfile() {
//    guard let myUser = User.current else {
//        print("Failed to get current user.")
//        return
//    }
//
//    let constraint = "username" == myUser.username
//    let query = User.query(constraint)
//
//    query.find { result in
//            switch result {
//            case .success(let users):
//                guard let currentUser = users.first else {
//                    print("Current user not found.")
//                    return
//                }
//                // Access custom properties for own user
//                if let name = currentUser.name {
//                    print("Name: \(name)")
//                }
//                if let breed = currentUser.breed {
//                    print("Breed: \(breed)")
//                }
//                if let age = currentUser.age {
//                    print("Age: \(age)")
//                }
//                if let bio = currentUser.bio {
//                    print("Bio: \(bio)")
//                }
//                if let preferences = currentUser.preferences {
//                    print("Preferences: \(preferences)")
//                }
//                if let images = currentUser.images {
//                    print("Images: \(images)")
//                }
//
//            case .failure(let error):
//                print("Error retrieving current user: \(error)")
//            }
//        }
//}


// To be declared in Signup view
// MARK: Handle login/logout with notification center
func signup(username: String, email: String, password: String) {
    // Create new user
    var newUser = User()
    newUser.username = username
    newUser.email = email
    newUser.password = password

    newUser.signup { result in // [weak self]
        switch result {
        case .success(let user):
            // Register login event
            NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
            print(user) // for now, to avoid type-checking warning message

        case .failure(let error):
            // TODO: Create & display error alert
            print(error.localizedDescription)
        }
    }
}


// To be declared in Login view
// MARK: Handle login/logout with notification center
func login(username: String, password: String) {
    User.login(username: username, password: password) { result in // [weak self]
        switch result {
        case .success(let user):            
            NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
            print(user) // for now, to avoid type-checking warning message

        case .failure(let error):
            // TODO: Create & Display error alert
            print(error.localizedDescription)
        }
    }
}


// To be declared in MyProfile view
// MARK: Handle login/logout with notification center
func logout() {
    // TODO: Create alert
    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    // TODO: Present alert
    alertController.addAction(logOutAction)
    alertController.addAction(cancelAction)
//    present(alertController, animated: true)
}

