//
//  DrawpadViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 17..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

protocol DrawingViewDelegate {
    func didFinishedDrawing(image: UIImage?, thumbnailIndex: Int)
}

class DrawpadViewController: UIViewController {

    @IBOutlet weak var drawingImageView: UIImageView!

    var thumbnailIndex = 0
    var delegate: DrawingViewDelegate?

    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var swiped = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions

    @IBAction func switchToPencil(_ sender: UIButton) {
        (red, green, blue) = (0.0, 0.0, 0.0)
    }

    @IBAction func switchToEraser(_ sender: UIButton) {
        (red, green, blue) = (1.0, 1.0, 1.0)
    }

    @IBAction func resetDrawingImageView(_ sender: UIButton) {
        drawingImageView.image = nil
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate?.didFinishedDrawing(image: drawingImageView.image, thumbnailIndex: thumbnailIndex)
        _ = navigationController?.popViewController(animated: true)
    }

    // MARK: - Drawing

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }

    func  drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        let drawingImageViewRect = self.drawingImageView.convert(self.drawingImageView.bounds, to: self.view)

        if drawingImageViewRect.contains(fromPoint) && drawingImageViewRect.contains(toPoint) {
            // Adjust the drawing points to fit in our drawingImageView
            let adjustedFromPoint = CGPoint(x: fromPoint.x - drawingImageViewRect.origin.x, y: fromPoint.y - drawingImageViewRect.origin.y)
            let adjustedToPoint = CGPoint(x: toPoint.x - drawingImageViewRect.origin.x, y: toPoint.y - drawingImageViewRect.origin.y)

            UIGraphicsBeginImageContext(self.drawingImageView.bounds.size)
            let context = UIGraphicsGetCurrentContext()
            drawingImageView.image?.draw(in: drawingImageView.bounds)

            context?.move(to: adjustedFromPoint)
            context?.addLine(to: adjustedToPoint)

            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(brushWidth)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            context?.setBlendMode(CGBlendMode.normal)

            context?.strokePath()

            drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
}
