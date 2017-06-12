//
//  TaskImageViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 14..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class TaskImageViewController: UIViewController {

    @IBOutlet weak var taskImageView: UIImageView!

    var countdownCounter = 10
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
        let taskImageName = getRandomTaskImageName()

        PatientModel.shared.createTestCaseToSave()
        PatientModel.shared.setTestCaseToSaveTaskImageName(name: taskImageName)

        self.taskImageView.image = UIImage(named: taskImageName)
        title = String(countdownCounter)
        countdown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRandomTaskImageName() -> String {
        let baseName = "task"
        let rnd = Int(arc4random_uniform(5)) + 1
        return baseName + String(rnd)
    }

    func countdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTitle), userInfo: nil, repeats: false)
    }

    func setTitle() {
        if (countdownCounter == 1) {
            performSegue(withIdentifier: "ShowDrawingGrid", sender: self)
        } else {
            countdownCounter -= 1
            title = String(countdownCounter)
            countdown()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
