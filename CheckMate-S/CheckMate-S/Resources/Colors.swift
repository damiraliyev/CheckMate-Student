//
//  Colors.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 17.03.2023.
//

import Foundation
import UIKit

extension UIColor {
    
    static let sduBlue = ColorAdapter.adapt(hexValue: "081F5C")
    
    static let sduLightBlue = ColorAdapter.adapt(hexValue: "002469")
    
    static let lightGreen = ColorAdapter.adapt(hexValue: "DEFFDB")
    
    static let lightYellow = ColorAdapter.adapt(hexValue: "FFF500")
    
    static let redOrange = ColorAdapter.adapt(hexValue: "E33538")
    
}

class ColorAdapter {
    
    static func adapt(hexValue: String) -> UIColor {
        let charArr = Array(hexValue)
        
        let hexInDecimal = [
            "0": 0,
            "1": 1,
            "2": 2,
            "3": 3,
            "4": 4,
            "5": 5,
            "6": 6,
            "7": 7,
            "8": 8,
            "9": 9,
            "A": 10,
            "B": 11,
            "C": 12,
            "D": 13,
            "E": 14,
            "F": 15,
        ]
        
        var r: CGFloat = 0;
        var g: CGFloat = 0;
        var b: CGFloat = 0;
        
        for i in stride(from: 0, to: charArr.count - 1, by: 2) {
           
            let decimalValue = CGFloat(hexInDecimal[String(charArr[i])]! * 16 + hexInDecimal[String(charArr[i + 1])]!)
            if i == 0 {
                r = CGFloat(decimalValue)
            } else if i == 2 {
                g = CGFloat(decimalValue)
            } else {
                b = CGFloat(decimalValue)
            }
        }
        print(r, g, b)
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
        
        
    }
    
    static func adapt(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat? = 100) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha ?? 100 / 100)
    }
}
