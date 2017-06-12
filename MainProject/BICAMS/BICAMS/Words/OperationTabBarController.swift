//
//  OperationTabBarController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 20..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit
import CoreData

class OperationTabBarController: UITabBarController {

    var resultCalculator = ResultCalculator()
    
    var currentTabBarItemIndex = 0
    
    var fetchedResultsController: NSFetchedResultsController<Word>?
    
    var fetchedWords = Dictionary<String, Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(red: 251, green: 15, blue: 68)
        
        for i in 1..<(tabBar.items?.count)! {
            
            tabBar.items?[i].isEnabled = false
        }
        
        fetchWords()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchWords() {
        
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: "category",
            cacheName: nil
        )
        
        try? fetchedResultsController?.performFetch()
        
        if let fetchedObjects = fetchedResultsController?.fetchedObjects {
            
            for o in fetchedObjects {
                
                if fetchedWords.keys.contains(o.category!) {
                    
                    fetchedWords[o.category!]?.append(o.data!.capitalizingFirstLetter())
                    
                } else {
                    
                    fetchedWords[o.category!] = [o.data!.capitalizingFirstLetter()]
                }
            }
        }
        
        fetchedWords = sortFetchedWordsByRandom()
    }
    
    private func sortFetchedWordsByRandom() -> Dictionary<String, Array<String>> {
        
        var useableWords = Dictionary<String, Array<String>>()
        
        var randomNums = [UInt32]()
        
        for k in fetchedWords.keys {
            
            randomNums.removeAll()
            
            for _ in 0..<4 {
                
                var randomNum: UInt32 = arc4random_uniform(UInt32((fetchedWords[k]?.count)!))
                
                while randomNums.contains(randomNum) {
                    randomNum = arc4random_uniform(UInt32((fetchedWords[k]?.count)!))
                }
                
                randomNums.append(randomNum)
                
                if useableWords[k] == nil {
                    
                    useableWords[k] = [String]()
                    
                }
                
                useableWords[k]?.append((fetchedWords[k]!)[Int(randomNum)])
            }
        }
    
        return useableWords
    }
    
    func addPoints(_ points: Int) {
        
        self.resultCalculator.tScore = self.resultCalculator.tScore + points
    }
    
    func calculateResult() {
        
        resultCalculator.calculate()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        for i in 0..<(tabBar.items?.count)! {
            
            if tabBar.items?[i] == item {
                
                if i >= currentTabBarItemIndex {
                    
                    currentTabBarItemIndex = i
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    
                } else {
                    
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
        }
        
        self.title = item.title
    }

}
