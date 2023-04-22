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
    var matchedUsers: [String]?
}


// For display in My Profile view
// MARK: The current plan is NOT to fetch all parts of profile upon login.
func getMyProfile() {
    guard let myUser = User.current else {
        print("Failed to get current user.")
        return
    }
    
    let constraint = "username" == myUser.username
    let query = User.query(constraint)
    
    query.find { result in
        // ... Store data of own user
    }
}


// To be defined in Feed view
// MARK: Is there a good way to specify constraints for the fetch, or do we have to pull everything and then filter?
// MARK: Maybe implement sorting profiles based on matching preferences
// Back4App Query Codebook: Queries with constraints involving array type fields?
let DEFAULT_MILE_DIAMETER: Double = 5
func getProfiles() {
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
    let query = User.query(constraint).include("user")

    query.find { result in // [weak self]
        switch result {
        case .success(let posts):
            // Update the local posts property with fetched posts
            print(posts) // for now, to avoid type-checking warning message
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}


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

