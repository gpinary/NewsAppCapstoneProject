//
//  Utilities.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 6.09.2023.
//

import Foundation
import UIKit

class Utilities {
    //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
