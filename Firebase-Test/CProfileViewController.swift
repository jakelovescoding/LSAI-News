//
//  CProfileViewController.swift
//  Firebase-Test
//
//  Created by Jake Jin on 11/19/23.
//

import UIKit

class CProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    
    @IBAction func cProfileAction(_ sender: Any) {
        // Save name and age
        UserDefaults.standard.set(nameField.text, forKey: "Name")
        UserDefaults.standard.set(ageField.text, forKey: "Age")

        // Save selectedCategories (assuming it's an array of strings)
        UserDefaults.standard.set(Array(selectedCategories), forKey: "SelectedCategories")

        // Synchronize UserDefaults
        UserDefaults.standard.synchronize()
        if let savedName = UserDefaults.standard.string(forKey: "Name"),
           let savedAge = UserDefaults.standard.string(forKey: "Age"),
           let savedCategories = UserDefaults.standard.array(forKey: "SelectedCategories") as? [String] {
            print("Saved Name: \(savedName)")
            print("Saved Age: \(savedAge)")
            print("Saved Categories: \(savedCategories)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let specificViewController = storyboard.instantiateViewController(withIdentifier: "tabBar")

        // Set the modal presentation style to fullscreen
        specificViewController.modalPresentationStyle = .fullScreen
        present(specificViewController, animated: true, completion: nil)

    }
    
    var categories = [
        "Technology",
        "Science",
        "Health",
        "Business",
        "Sports",
        "Entertainment",
        "Education",
        "Food",
        "Travel",
        "Fashion",
        "Music",
        "Art",
        "Movies",
        "Books",
        "Fitness",
        "Home & Garden",
        "Pets",
        "Automotive",
        "Finance",
        "Lifestyle"
    ]
    var selectedCategories: Set<String> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in your table view
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell with your data
        let category = categories[indexPath.row]
        cell.textLabel?.text = categories[indexPath.row]
        cell.backgroundColor = selectedCategories.contains(category) ? UIColor.systemYellow : UIColor.white
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]

        if selectedCategories.contains(selectedCategory) {
            // Deselect the category
            selectedCategories.remove(selectedCategory)
        } else {
            // Select the category
            selectedCategories.insert(selectedCategory)
        }

        // Reload the selected row to update its appearance
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @IBOutlet weak var categoryTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the table view
        categoryTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.layer.borderWidth = 1.0
        categoryTable.layer.borderColor = UIColor.black.cgColor
        categoryTable.layer.cornerRadius = 8.0 // Optional: Add rounded corners if desired
    }
    
}
