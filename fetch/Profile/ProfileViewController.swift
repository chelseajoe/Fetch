//
//  ProfileViewController.swift
//  fetch
//
//  Created by Chelsea Joe on 4/13/23.
//

import UIKit
import ParseSwift
import Alamofire
import AlamofireImage
import PhotosUI

class ProfileViewController: UIViewController {

//    var user: User!
    
    // Define the query
    @IBOutlet weak var profileImageView: UIImageView!
//    let query = Query<User>()
    @IBOutlet weak var smallImageLeftView: UIImageView!
    
    @IBOutlet weak var smallImageMiddleView: UIImageView!
    
    @IBOutlet weak var smallImageRightView: UIImageView!
    
    private var pickedImage: UIImage?
    private var buttonTag: Int?

    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var breedTextView: UITextView!
    
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var nameAndAgeLabel: UILabel!

    @IBOutlet weak var preferencesTextView: UITextView!
    

    @IBOutlet weak var ProfileEditButton: UIButton!
    
    @IBOutlet weak var LeftEditButton: UIButton!
    
    @IBOutlet weak var RightEditButton: UIButton!
    
    @IBOutlet weak var MiddleEditButton: UIButton!

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    @IBAction func onPickedImageTapped(_ sender: UIButton) {

        // Create a configuration object
        buttonTag = sender.tag

        var config = PHPickerConfiguration()

        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images

        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current

        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker
        present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileEditButton.tag = 1
        LeftEditButton.tag = 2
        MiddleEditButton.tag = 3
        RightEditButton.tag = 4
        
       
        // This function exists in User.swift
        // load profile
        getMyProfile { name, breed, age, bio, preferences, images in
            // Update UI or perform any other action with the retrieved data
            DispatchQueue.main.async {
                // Update UI elements with the retrieved data
                self.nameAndAgeLabel.text = name
                self.breedTextView.text = breed
                self.descriptionTextView.text = bio
                self.preferencesTextView.text = preferences?.joined(separator: ", ")
                // Handle images using ParseSwift's file handling methods
                if let url = images?.first?.url {
                    // Use AlamofireImage helper to fetch remote image from URL
                    let imageDataRequest = AF.request(url).responseImage { [weak self] response in
                        switch response.result {
                            case .success(let image):
                                // Set image view image with fetched image
                                self?.profileImageView.image = image
                            case .failure(let error):
                                print("❌ Error fetching image: \(error.localizedDescription)")
                                break
                        }
                    }
                    
                } else {
                    print("No data found")
                }

            }
        }

    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func onLogoutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Dismiss the picker
        picker.dismiss(animated: true)
        
        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
              // Make sure the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else {
                
                // ❌ Unable to cast to UIImage
                self?.showAlert()
                return
            }
            
            // Check for and handle any errors
            if error != nil {
                //              self?.showAlert(error: error)
                return
            } else {
                // Create a Parse File by providing a name and passing in the image data
                var imageFileName = "image.jpg"
                 
                 if (self?.buttonTag == 1) {
                     imageFileName = "Profile0.jpg"
                 } else if (self?.buttonTag == 2) {
                     imageFileName = "Profile1.jpg"
                 } else if (self?.buttonTag == 3) {
                     imageFileName = "Profile2.jpg"
                 } else {
                     imageFileName = "Profile3.jpg"
                 }
                
                // Set image on preview image view
                guard let imageData = image.jpegData(compressionQuality: 0.1) else {
                           return
                       }
                
                // Create a Parse File by providing a name and passing in the image data
                 let imageFile = ParseFile(name: imageFileName, data: imageData)
                
                if var currentUser = User.current {
                    if currentUser.images == nil {
                        currentUser.images = []
                    }
                    currentUser.images?.append(imageFile)
                    
                    currentUser.save { [weak self] result in
                    
                        // UI updates (like setting image on image view) should be done on main thread
                        DispatchQueue.main.async {
                            // Set image to use when saving post
                            self?.pickedImage = image
                            
                            if (self?.buttonTag == 1) {
                                self?.profileImageView.image = image
                                
                            } else if (self?.buttonTag == 2) {
                                self?.smallImageLeftView.image = image
                                
                            } else if (self?.buttonTag == 3) {
                                self?.smallImageMiddleView.image = image
                                
                            } else {
                                self?.smallImageRightView.image = image
                                
                            }
                            
                            
                        }
                    }
                }
                
            }
        }
    }
    
    
}
