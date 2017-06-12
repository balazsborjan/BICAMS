//
//  TaskOrSolutionViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 09..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class TaskOrSolutionViewController: UIViewController {

    @IBOutlet weak var taskOrSolutionImageView: UIImageView!

    var taskOrSolutionImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskOrSolutionImageView.image = taskOrSolutionImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
