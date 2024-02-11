//
//  ProfileViewController.swift
//  Firebase-Test
//
//  Created by Jake Jin on 11/19/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var actionsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = UserDefaults.standard.string(forKey: "Name")!
        
        var initial = String((UserDefaults.standard.string(forKey: "Name")?.first)!)
        
        profileLabel.textColor = UIColor.white
        profileLabel.text = initial
        
        nameView.layer.borderColor = UIColor.black.cgColor // Set the desired outline color
        nameView.layer.borderWidth = 1.0 // Set the desired outline width
        nameView.layer.cornerRadius = 8.0
        
        actionsView.layer.borderColor = UIColor.black.cgColor // Set the desired outline color
        actionsView.layer.borderWidth = 1.0 // Set the desired outline width
        actionsView.layer.cornerRadius = 8.0

        
    }
    @IBOutlet weak var profileLabel: UILabel!

}
