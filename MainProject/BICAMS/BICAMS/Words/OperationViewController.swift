//
//  OperationViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 13..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit

class OperationViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var newOperationButton: UIButton!
    
    @IBOutlet weak var showResultsButton: UIButton!

    @IBOutlet weak var infoTableView: UITableView!
    
    var mainVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "\(patient!.firstName!) \(patient!.lastName!)"
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.contentMode = .redraw
        
        setInfoTableViewRowHeight()
        setInfoTableViewHeaderSeparator()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Kezdőoldal", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setInfoTableViewRowHeight()
        infoTableView.reloadData()
    }
    
    private func setInfoTableViewRowHeight() {
        
        let rowNum = CGFloat(infoTableView.numberOfRows(inSection: 0))
        
        let tvHeight = (self.view.frame.maxY - (self.navigationController?.navigationBar.frame.maxY)!) / 3 - 20
        
        infoTableView.rowHeight = tvHeight / rowNum
        infoTableView.estimatedRowHeight = tvHeight / rowNum
    }
    
    private func setInfoTableViewHeaderSeparator() {
    
        let px = 1 / UIScreen.main.scale
        let frame =  CGRect(x: 0, y: 0, width: self.infoTableView.frame.width, height: px)
        let line = UIView(frame: frame)
        self.infoTableView.tableHeaderView = line
        line.backgroundColor = self.infoTableView.separatorColor
    }
    
    @objc private func back() {
        
        for viewController in (self.navigationController?.viewControllers)! {
            
            if viewController is HomePageViewController {
                
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "showResultsSegue" {
                
                if let destinationVC = segue.destination as? ResultsViewController {
                    
                    destinationVC.navigationItem.title = (sender as? UIButton)?.currentTitle ?? ""
                }
            }
        }        
    }
}

extension OperationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientInfoTableViewCell", for: indexPath)
        
        if let patientInfoCell = cell as? PatientInfoTableViewCell {
            
            if patient != nil {
                
                switch indexPath.row {
                case 0:
                    patientInfoCell.titleLabel.text = "Nem"
                    patientInfoCell.detailLabel.text = patient!.sexType == 0 ? "Nő" : "Férfi"
                case 1:
                    patientInfoCell.titleLabel.text = "Születési dátum"
                    patientInfoCell.detailLabel.text = "\(patient!.birthDate!.toString()) (\(Date.getPatientAge()))"
                case 2:
                    patientInfoCell.titleLabel.text = "TAJ szám"
                    patientInfoCell.detailLabel.text = patient!.taj
                    
                    cell.preservesSuperviewLayoutMargins = false
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                default:
                    break
                }
                
                return patientInfoCell
            }
        }
        
        return cell
    }
}






