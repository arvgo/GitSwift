//
//  Github Vc.swift
//  GitView
//
//  Created by RAG on 21/11/2018.
//  Copyright © 2018 RAG. All rights reserved.
//

import UIKit

let reuseIdentifier = "commitViewCell"

class GithubVc: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listOfGitCommits:[GitList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // API address for Githup Commits
        let jsonUrlString = "https://api.github.com/repos/apple/swift/commits"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data  = data else { return }
            
            do  {
                let gitResults = try JSONDecoder().decode([GitList].self, from: data)
                
                DispatchQueue.main.async {
                    self.listOfGitCommits = gitResults
                    self.collectionView?.reloadData()
                }
                
            } catch let jsonErr {
                print("Error Serializing json: ", jsonErr)
            }
            
            }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfGitCommits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commitViewCell", for: indexPath) as! GitCollectionViewCell
        
        // Add bottom line to cell
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: cell.frame.height - 2, width:  cell.frame.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.red.cgColor
        cell.layer.addSublayer(bottomLine)
        
        // Commit Title
        cell.titleLabel.text = "Title: " + self.listOfGitCommits[indexPath.item].commit.message
        
        // Author Name
        cell.authorName.text = "Author: " + self.listOfGitCommits[indexPath.item].commit.author.name
        
        // Author Image
        let imageUrlString = self.listOfGitCommits[indexPath.item].author.avatarURL
        let imageURL:URL = URL(string: imageUrlString)!
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                cell.authorImage.image = UIImage(data: data!)
            }
        }
        
        // Time of Commit
        let dbDateFormatter = DateFormatter()
        dbDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = dbDateFormatter.date(from: self.listOfGitCommits[indexPath.item].commit.author.date){
            let dateFormatter = DateFormatter()
            // Date format (e.g. 17:40:33, 21 Nov 2018)
            dateFormatter.dateFormat = "HH:mm:ss, dd MMM yyyy"
            let commitDate = dateFormatter.string(from: date)
            cell.dateCommit.text = "Date of Commit : " + commitDate
        }
        return cell
    }
}

