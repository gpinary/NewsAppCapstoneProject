//
//  UIView+Extension.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 5.09.2023.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get{ return self.cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
