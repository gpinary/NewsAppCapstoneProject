//
//  UIViewController+Extension.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 9.09.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}
