//
//  OperationTableViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 20..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

extension UIApplication {
    
    var statusBarView: UIView? {
        
        return value(forKey: "statusBar") as? UIView
    }
}

extension String {
    
    func capitalizingFirstLetter() -> String {
        
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        
        self = self.capitalizingFirstLetter()
    }
}

class OperationTableViewController: UITableViewController {

    var points: Int = 0
    
    var fetchedWords = Dictionary<String, Array<String>>()
    
    var isSelectionEnabled = true
    
    var adjustForTabbarInsets: UIEdgeInsets!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentMode = .redraw
        
        setInsets()
        setTableViewRowHeight()
        
        if let tabBarC = self.tabBarController as? OperationTabBarController {
            
            if tabBarC.currentTabBarItemIndex > 0 {
                
                self.tabBarController?.navigationItem.hidesBackButton = true
                self.tabBarController?.navigationItem.leftBarButtonItem = nil
                
            } else {
        
                let cancelOperationBarButtonItem = UIBarButtonItem(title: "Megszakít", style: .plain, target: self, action: #selector(cancelOperation))
                self.tabBarController?.navigationItem.setLeftBarButton(cancelOperationBarButtonItem, animated: true)
            }
        }
        
        let finishOperationBarButtonItem = UIBarButtonItem(title: "Kész", style: .plain, target: self, action: #selector(finishOperation))
        
        self.tabBarController?.navigationItem.setRightBarButton(finishOperationBarButtonItem, animated: true)
        
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        self.tabBarController?.title = self.tabBarItem.title
        
        self.fetchedWords = ((self.tabBarController as? OperationTabBarController)?.fetchedWords)!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setInsets()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (_) in
            
            self.setTableViewRowHeight()
            self.tableView.reloadData()
        }
    }
    
    private func setInsets() {
        
        adjustForTabbarInsets = UIEdgeInsetsMake((self.navigationController?.navigationBar.frame.maxY)!, 0, 0, 0);
        
        self.tableView.contentInset = adjustForTabbarInsets;
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
    }
    
    @objc private func finishOperation() {
        
        let finishOperationAlert = UIAlertController(
            title: "Aktuális vizsgálat befejezése",
            message: "", preferredStyle: .alert)
        
        finishOperationAlert.addAction(UIAlertAction(title: "Mégsem", style: .default, handler: { (action: UIAlertAction) in
            //Do nothing
        }))
        
        finishOperationAlert.addAction(UIAlertAction(title: "Befejezés", style: .default, handler: { (action: UIAlertAction) in
            
            self.isSelectionEnabled = false
            
            if let tabBarC = self.tabBarController as? OperationTabBarController {
             
                tabBarC.addPoints(self.points)
                
                if tabBarC.currentTabBarItemIndex == (tabBarC.tabBar.items?.count)! - 1 {
                    
                    tabBarC.calculateResult()
                    
                    for viewController in (self.navigationController?.viewControllers)! {
                        
                        if viewController is ResultsViewController {
                        
                            (viewController as! ResultsViewController).backBarButtonChangeNeeded = true
                            
                            self.navigationController?.popToViewController(viewController, animated: true)
                            return
                        }
                    }
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    if let resultVC = storyBoard.instantiateViewController(withIdentifier: "resultsViewController") as? ResultsViewController {
                        
                        resultVC.backBarButtonChangeNeeded = true
                        
                        self.navigationController?.viewControllers.append(resultVC)
                        self.navigationController?.popToViewController(resultVC, animated: true)
                    }
                    
                } else {
                    
                    tabBarC.currentTabBarItemIndex = tabBarC.currentTabBarItemIndex + 1
                    
                    tabBarC.tabBar.items?[tabBarC.currentTabBarItemIndex].isEnabled = true
                    tabBarC.selectedIndex = tabBarC.currentTabBarItemIndex
                }
            }
        }))
        
        self.present(finishOperationAlert, animated: true, completion: nil)
    }
    
    @objc private func cancelOperation() {
        
        let cancelOperationAlert = UIAlertController(title: "Vizsgálat megszakítása", message: "Biztosan megszakítja a vizsgálatot?", preferredStyle: .alert)
        
        cancelOperationAlert.addAction(UIAlertAction(title: "Megszakítás", style: .destructive, handler: { (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        cancelOperationAlert.addAction(UIAlertAction(title: "Mégsem", style: .default, handler: { (action: UIAlertAction) in
            //Do nothing
        }))
        
        self.present(cancelOperationAlert, animated: true, completion: nil)
    }
    
    private func setTableViewRowHeight() {
        
        let orientation = UIDevice.current.orientation
        
        let topY = (self.tabBarController?.navigationController?.navigationBar.frame.maxY)!
        
        let bottomY = self.tabBarController?.tabBar.frame.minY
        
        let tvHeight = bottomY! - topY
        
        let rowHeight = tvHeight / 16
        
        if orientation == .portrait || ((orientation == .faceUp || orientation == .faceDown) && (self.view.frame.width < self.view.frame.height)) {
            
            tableView.isScrollEnabled = false
            tableView.rowHeight = rowHeight
            tableView.estimatedRowHeight = rowHeight
            tableView.scrollsToTop = true
            
        } else {
            
            tableView.isScrollEnabled = true
            tableView.rowHeight = rowHeight * 2
            tableView.estimatedRowHeight = rowHeight * 2
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedWords.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "operationTVC", for: indexPath)

        if let operationTVC = cell as? OperationTableViewCell {
            
            let currentWord = Array(fetchedWords.values)[indexPath.section][indexPath.row]
            
            operationTVC.wordLabel.text = currentWord
            
            if operationTVC.isSelected {
                
                let backgroundView = UIView(frame: (operationTVC.frame))
                
                operationTVC.selectedBackgroundView = backgroundView
                operationTVC.selectedBackgroundView?.backgroundColor = UIColor.green
            }
            
            return operationTVC
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSelectionEnabled {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            let backgroundView = UIView(frame: (cell?.frame)!)
            
            cell?.selectedBackgroundView = backgroundView
            cell?.selectedBackgroundView?.backgroundColor = UIColor.green
            
            self.points = self.points + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if isSelectionEnabled {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            let backgroundView = UIView(frame: (cell?.frame)!)
            
            cell?.selectedBackgroundView = backgroundView
            cell?.selectedBackgroundView?.backgroundColor = UIColor.white
            
            self.points = self.points - 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if isSelectionEnabled {
            
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if isSelectionEnabled {
            
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? OperationTableViewCell {
            
            //let language = Locale.current.languageCode
            let language = "hu"
            
            let voice = AVSpeechSynthesisVoice(language: language)
            
            if let text = cell.wordLabel.text {
                
                let toSay = AVSpeechUtterance(string: text)
                
                toSay.voice = voice
                
                let spk = AVSpeechSynthesizer()
                spk.speak(toSay)
            }
        }
    }
}










