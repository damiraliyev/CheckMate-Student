//
//  Extension.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 16.03.2023.
//

import Foundation
import UIKit

extension UIButton {
    func animatePress() {
        alpha = 0.5

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.alpha = 1
        }

    }
}


extension String {
    static func date(from date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter.string(from: date)
    }
}
