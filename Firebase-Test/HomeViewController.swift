//
//  HomeViewController.swift
//  Firebase-Test
//
//  Created by Jake Jin on 11/19/23.
//
import UIKit

import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Article: Decodable {
    @DocumentID var id: String?
    var category: String
    var content: String
    var created_at: Date
    var image: String
    var title: [String]
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.cornerRadius = 8.0 // Optional: Add rounded corners if desired
        
        searchDatabase(searchStr: "Spears") { [weak self] (articles, error) in
            if let error = error {
                // Handle the error
                print("Error: \(error)")
            } else if let articles = articles {
                // Update the articles array and reload the table view
                self?.articles = articles
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            }
        }
    }
    func searchDatabase(searchStr: String, completion: @escaping ([Article]?, Error?) -> Void) {
        var documents: [QueryDocumentSnapshot] = []
        
        Firebase.Firestore.firestore().collection("news_classification").limit(to: 10).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, error) // Pass the error to the completion handler
            } else {
                for document in querySnapshot!.documents {
                    documents.append(document)
                }
                let articles = self.processDocuments(documents: documents)
                completion(articles, nil) // Pass the articles to the completion handler
            }
        }
    }
    func processDocuments(documents: [QueryDocumentSnapshot]) -> [Article]{
        var articles: [Article] = []
        
        for doc in documents {
            if let article = try? doc.data(as: Article.self) {
                articles.append(article)
            } else {
                // Handle the case where data cannot be parsed into Article type
                print("Error parsing document data for document ID: \(doc.documentID)")
            }
        }
        
        
        // Now you have an array of Article objects
        return articles
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ArticleTableViewCell
        
        let article = articles[indexPath.row]
        cell.titleLabel.text = article.title.joined(separator: " ")
        let url = URL(string: article.image)
        getData(from: url!) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async() { [weak self] in
                    cell.articleImageView.image = UIImage(data: data)
                }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy HH:mm"
        
        cell.dateLabel.text = formatter.string(from: article.created_at)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        performSegue(withIdentifier: "showArticleDetail", sender: selectedArticle)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArticleDetail",
           let articleDetailVC = segue.destination as? ArticleDetailViewController,
           let selectedArticle = sender as? Article {
            articleDetailVC.article = selectedArticle
        }
    }
    
    
}

class ArticleDetailViewController: UIViewController {

    var article: Article?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var articleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let article = article {
                    titleLabel.text = article.title.joined(separator: " ")
            contentTextView.text = article.content.replacingOccurrences(of: "\n", with: "")
//            contentTextView.layer.borderColor = UIColor.black.cgColor // Set the desired outline color
//            contentTextView.layer.borderWidth = 1.0 // Set the desired outline width
//            contentTextView.layer.cornerRadius = 8.0
            
            
            let url = URL(string: article.image)
            getData(from: url!) { data, response, error in
                    guard let data = data, error == nil else { return }

                    DispatchQueue.main.async() { [weak self] in
                        self!.articleImage.image = UIImage(data: data)
                    }
            }
            articleImage.layer.cornerRadius = 8.0
            articleImage.layer.masksToBounds = true
        }
        
        
        
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
