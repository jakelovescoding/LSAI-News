//
//  SearchViewController.swift
//  Firebase-Test
//
//  Created by Jake Jin on 10/29/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
class SearchViewController: UIViewController {
    
    
    struct Article: Decodable {
        @DocumentID var id: String?
        var category: String
        var content: String
        var created_at: Date
        var image: String
        var title: [String]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchDatabase(searchStr: "Spears") { (articles, error) in
            if let error = error {
                // Handle the error
                print("Error: \(error)")
            } else if let articles = articles {
                // Use the articles array here
                print("Articles: \(articles)")
            }
        }
        }
        
        func searchDatabase(searchStr: String, completion: @escaping ([Article]?, Error?) -> Void) {
            var documents: [QueryDocumentSnapshot] = []
            
            FirebaseFirestore.Firestore.firestore().collection("news_classification").whereField("title", arrayContains: searchStr).getDocuments { (querySnapshot, error) in
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
    }

