//
//  ResultsViewController.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 23..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chartContainer: ChartContainer!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var avarageLabel: UILabel!
    
    @IBOutlet weak var chart: Chart!
    
    @IBOutlet weak var resultinfoTableView: UITableView!
    
    @IBOutlet weak var dateLabels: UIStackView!
    
    var resultInfoData: (min: Int32, max: Int32, avg: Double) = (0, 0, 0.0)
    
    var backBarButtonChangeNeeded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GradientLayerGenerator.SetDefaultGradientColorTo(view: chartContainer)
        
        let minResult = Array(patient!.results!).map { ($0 as! Result).point }.min()
        
        let maxResult = patient!.results!.map { ($0 as! Result).point }.max()
        
        let avgResult =  patient!.results!.map { ($0 as! Result).point }.average
        
        resultInfoData = (minResult ?? 0, maxResult ?? 0, avgResult)
        
        drawChartViewByOrientation()
        
        setupInfoLabels(avg: avgResult)
        
        setupDateLabels()
        
        if backBarButtonChangeNeeded {
            
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "Adatlap", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
    }
    
    @objc private func back() {
        
        for viewController in (self.navigationController?.viewControllers)! {
            
            if viewController is OperationViewController {
                
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
    
    private func setupInfoLabels(avg: Double) {
        
        if patient != nil {
            
            self.nameLabel.text = "\(patient!.firstName!) \(patient!.lastName!)"
            self.avarageLabel.text = "Átlag: \(avg)"
        }
    }
    
    private func setupDateLabels() {
        
        var subviews: [UIView] = []
        
        switch chart.resultSet.count {
        case 1:
            subviews.append(dateLabels.subviews[2])
        case 2:
            subviews.append(dateLabels.subviews[1])
            subviews.append(dateLabels.subviews[3])
        case 3:
            subviews.append(dateLabels.subviews[1])
            subviews.append(dateLabels.subviews[2])
            subviews.append(dateLabels.subviews[3])
        case 4:
            subviews.append(dateLabels.subviews[0])
            subviews.append(dateLabels.subviews[1])
            subviews.append(dateLabels.subviews[2])
            subviews.append(dateLabels.subviews[3])
        case 5:
            subviews = dateLabels.subviews
        default:
            break
        }
        
        for i in 0..<subviews.count {
            
            if let label = subviews[i] as? UILabel {
                
                let currentResult = chart.resultSet[i]
                
                if i == 0 || (currentResult.date! as Date).getMonth() != (chart.resultSet[i - 1].date! as Date).getMonth() {
                    
                    label.text = (chart.resultSet[i].date! as Date).getMonthAndDay()
                    
                } else {
                    
                    label.text = (chart.resultSet[i].date! as Date).getDay()
                }
            }
        }
    }
    
    // MARK: - ChartView
    
    private func drawChartViewByOrientation() {
        
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            
            drawChartView(chartViewHeightScale: CGFloat(2))
            
        case .faceUp, .faceDown:
            
            (self.view.frame.width < self.view.frame.height) ? drawChartView(chartViewHeightScale: CGFloat(2)) : drawChartView(chartViewHeightScale: nil)
            
        default:
            
            drawChartView(chartViewHeightScale: nil)
        }
    }
    
    private func drawChartView(chartViewHeightScale: CGFloat?) {
        
        if patient != nil {
            
            if patient!.results != nil {
                
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
                
                if patient!.results!.count > 4 {
                    
                    let slice : Array<Result> = Array((patient!.results!.sortedArray(using: [sortDescriptor]) as! [Result])[0...4])
                    chart.resultSet = slice
                    
                } else {
                    
                    chart.resultSet = (patient!.results!.sortedArray(using: [sortDescriptor]) as! [Result])
                }
            }
        }
    }
    
    // MARK: - TableView
    
    private func setInfoTableViewHeaderSeparator() {
        
        if resultinfoTableView != nil {
            
            let px = 1 / UIScreen.main.scale
            let frame =  CGRect(x: 0, y: 0, width: resultinfoTableView.frame.width, height: px)
            let line = UIView(frame: frame)
            resultinfoTableView.tableHeaderView = line
            line.backgroundColor = resultinfoTableView.separatorColor
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNum = indexPath.row
        
        let identifierIdx = Int(rowNum + 1)
        
        let identifier = "resultInfo\(identifierIdx)"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            
            switch identifierIdx {
            case 1:
                cell.detailTextLabel?.text = String(describing: resultInfoData.min)
            case 2:
                cell.detailTextLabel?.text = String(describing: resultInfoData.max)
            case 3:
                cell.detailTextLabel?.text = String(describing: resultInfoData.avg)
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
