//
//  ViewController.swift
//  WordScrambel
//
//  Created by Ravi Singh on 28/05/20.
//  Copyright © 2020 Ravi Singh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allwords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addText))
        
      textPath()
        
       
    }
    
    
    func textPath() {
        if let path = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: path) {
                allwords = startWords.components(separatedBy: "\n")
            }
        }else  {
            
            if allwords.isEmpty {
                allwords = ["no words"]
            }
            
            
        }
        
        startGame()
    }
    
    
    func startGame() {
        title = allwords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func addText () {
        let alert = UIAlertController(title: "Enter Words", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            
            guard let answer = alert?.textFields?[0].text else{return}
            self?.submit(answer)
            
        }
        alert.addAction(submitAction)
        present(alert, animated: true)
        
        
    }
    
    func submit (_ answer : String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(words: lowerAnswer) {
            if isOriginal(words: lowerAnswer) {
                if isReal(words: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let index = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [index], with: .automatic)
                    return
                }else {
                    errorTitle = "word not recognized"
                    errorMessage = "you can't make them up, you know"
                }
            }else{
                errorTitle = "word already used"
                errorMessage = "Be more origanl"
            }
        }else {
            guard let title = title else {return}
            errorTitle = "word not possible"
            errorMessage = "you can't spell that word from\(title.lowercased())."
        }
        
        let alert = UIAlertController.init(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
    }
    
    func isPossible (words: String) -> Bool {
        guard var tempWords = title?.lowercased() else {return false}
        for letter in words {
            if let position = tempWords.firstIndex(of: letter){
                tempWords.remove(at: position)
            }else {
                return false
            }
        }

        return true
    }
    func isOriginal (words: String) -> Bool {
        
        return !usedWords.contains(words)
    }
    
    func isReal (words: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: words.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: words, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
}


