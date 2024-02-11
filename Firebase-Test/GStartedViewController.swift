//
//  SearchViewController.swift
//  Firebase-Test
//
//  Created by Jake Jin on 10/29/23.
//

import UIKit
class GStartedViewController: UIViewController {
    
    @IBAction func startButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let specificViewController = storyboard.instantiateViewController(withIdentifier: "CProfile")

        // Set the modal presentation style to fullscreen
        specificViewController.modalPresentationStyle = .fullScreen

        // Present the target view controller
        present(specificViewController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    }

