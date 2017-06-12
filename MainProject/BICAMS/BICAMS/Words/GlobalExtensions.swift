//
//  GlobalExtensions.swift
//  BICAMS
//
//  Created by Balázs Bojrán on 2017. 06. 12..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == Int32 {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(count)
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func chartViewColor0() -> UIColor {
        
        return UIColor(red: 248, green: 91, blue: 72)
    }
    
    class func chartViewColor1() -> UIColor {
        
        return UIColor(red: 244, green: 76, blue: 60)
    }
    
    class func chartViewColor2() -> UIColor {
        
        return UIColor(red: 242, green: 35, blue: 36)
    }
}
