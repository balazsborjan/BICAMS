//
//  DrawingGridViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 16..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class DrawingGridViewController: UIViewController {

    @IBOutlet weak var thumbnailCollectionView: UICollectionView!

    let minimalSpacing: CGFloat = 4.0
    var sectionInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

    var solutionImages: [UIImage?] = Array(repeating: nil, count: 6)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TODO: Add alert before saving an unwinding.
    @IBAction func submitButtonPressed(_ sender: UIBarButtonItem) {
        let currentDate = Date()

        PatientModel.shared.setTestCaseToSaveDate(date: currentDate)

        let solutionImage = createSolutionImageFromThumbnails()
        let solutionImageData = UIImagePNGRepresentation(solutionImage)!

        PatientModel.shared.setTestCaseToSaveSolutionImageData(data: solutionImageData)

        PatientModel.shared.saveTestCaseToSave()

        // Test is over back to patient list.
        performSegue(withIdentifier: "unwindSegueToPatientList", sender: self)
    }
    
    func createSolutionImageFromThumbnails() -> UIImage {
        let resultImageSize = CGSize(width: 800, height: 1200)

        UIGraphicsBeginImageContext(resultImageSize)

        // Set background color to white
        UIColor.white.set()
        UIRectFill(CGRect(origin: .zero, size: resultImageSize))

        for (index, value) in solutionImages.enumerated() {
            let xCoordMultiplier = index % 2
            var yCoordMultiplier = 0
            if index == 2 || index == 3 {
                yCoordMultiplier = 1
            } else if index > 3 {
                yCoordMultiplier = 2
            }

            let imageRect = CGRect(x: xCoordMultiplier * 400, y: yCoordMultiplier * 400, width: 400, height: 400)
            value?.draw(in: imageRect)
        }

        let resultImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return resultImage
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDrawpad" {
            let destination = segue.destination as! DrawpadViewController

            let cell = sender as! ThumbnailCollectionViewCell
            let indexPath = thumbnailCollectionView.indexPath(for: cell)
            destination.thumbnailIndex = indexPath!.row
            destination.delegate = self
        }
    }
}

extension DrawingGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let minimalPaddingSpaceForWidth = minimalSpacing * 3
        let minimalPaddingSpaceForHeight = minimalSpacing * 4

        let availableWidth = collectionView.bounds.size.width - minimalPaddingSpaceForWidth
        let widthPerItem = availableWidth / 2

        let availableHeight = collectionView.bounds.size.height - minimalPaddingSpaceForHeight
        let heightPerItem = availableHeight / 3

        if widthPerItem <= heightPerItem {
            let topAndBottomInsets = collectionView.bounds.size.height - (widthPerItem * 3) - (minimalSpacing * 2)
            sectionInsets.top = topAndBottomInsets / 2
            sectionInsets.bottom = topAndBottomInsets / 2
            return CGSize(width: widthPerItem, height: widthPerItem)
        } else {
            let leftAndRightInsets = collectionView.bounds.size.width - (heightPerItem * 2) - (minimalSpacing * 1)
            sectionInsets.left = leftAndRightInsets / 2
            sectionInsets.right = leftAndRightInsets / 2
            return CGSize(width: heightPerItem, height: heightPerItem)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrawingThumbnail", for: indexPath) as! ThumbnailCollectionViewCell

        if let img = solutionImages[indexPath.row] {
            cell.imageView.image = img
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimalSpacing
    }
}

extension DrawingGridViewController: DrawingViewDelegate {
    func didFinishedDrawing(image: UIImage?, thumbnailIndex: Int) {
        solutionImages[thumbnailIndex] = image
        let indexPath = IndexPath(row: thumbnailIndex, section: 0)
        thumbnailCollectionView.reloadItems(at: [indexPath])
    }
}
