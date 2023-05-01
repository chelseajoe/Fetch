//
//  PlaymatesDetailViewController.swift
//  fetch
//
//  Created by Pei Qi Tea on 24/4/23.
//

import UIKit

class PlaymatesDetailViewController: UIViewController {
    
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet weak var breedLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var preferencesLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (user != nil) {
            if (user?.age != nil) {
                self.nameAgeLabel.text = (user?.name)! + ", " + String(user?.age! ?? 0)
            } else {
                self.nameAgeLabel.text = user?.name!
            }
            
            self.breedLabel.text = user?.breed ?? "No breed stated."
            
            self.bioLabel.text = user?.bio ?? "No bio written yet."
            
            if user?.preferences == nil {
                self.preferencesLabel.text = "No preferences stated."
            } else {
                self.preferencesLabel.text = user?.preferences?.joined()
            }
            
            //self.locationLabel.text = user?.location
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

}
