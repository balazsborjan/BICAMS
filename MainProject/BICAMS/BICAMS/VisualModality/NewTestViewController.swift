//
//  NewTestViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 06..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class NewTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    TODO: Get rid of these commented code
//    @IBAction func createNewTest(_ sender: UIButton) {
//        let date = Date()
//        let taskImageName = getRandomTaskImageName()
//
//        let solutionImageName = getRandomTaskImageName()
//        let solutionImage = UIImage(named: solutionImageName)
//        let solutionImageData = UIImagePNGRepresentation(solutionImage!)
//
//        PatientModel.shared.createTestCaseWith(date: date, taskImageName: taskImageName, solutionImageData: solutionImageData!)
//        _ = navigationController?.popViewController(animated: true)
//    }

//    func getRandomTaskImageName() -> String {
//        let baseName = "task"
//        let rnd = Int(arc4random_uniform(5)) + 1
//        return baseName + String(rnd)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
