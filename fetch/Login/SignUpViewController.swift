//
//  SignUpViewController.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/1/22.
//

import UIKit
import CoreLocation

// TODO: Pt 1 - Import Parse Swift
import ParseSwift

class SignUpViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var locations: [CLLocation] = []

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dogsNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Location services authorized when in use or always
            // Start updating location
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Location services denied or restricted
            // Display an error message to the user or provide alternative functionality
            print("Location services denied or restricted.")
        case .notDetermined:
            // Location services not determined yet
            // You can request authorization here again if needed
            break
        @unknown default:
            // Handle unknown authorization status
            break
        }
    }

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // Handle location updates
       // The latest location is available in the 'locations' array
       self.locations.append(contentsOf: locations)
       print("Latitude: \(locations.last?.coordinate.latitude ?? 0), Longitude: \(locations.last?.coordinate.longitude ?? 0)")
   }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location update error
        print("Location update error: \(error.localizedDescription)")
    }

    @IBAction func onSignUpTapped(_ sender: Any) {

        // Make sure all fields are non-nil and non-empty.
        guard let username = usernameField.text,
              let name = dogsNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }

        // TODO: Pt 1 - Parse user sign up
        var newUser = User()
        newUser.username = username
        newUser.name = name
        newUser.email = email
        newUser.password = password
        
        // Get the last location from Core Location
        if let location = locations.last {
            // Create a ParseGeoPoint object with the latitude and longitude
            let geoPoint = try? ParseGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            // Set the geoPoint as the value of newUser.location
            newUser.location = geoPoint
            
        } else {
            // Handle the case where location is not available
            print("Location is not available")
        }
        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
