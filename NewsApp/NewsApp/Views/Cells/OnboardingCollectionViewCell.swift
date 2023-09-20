//
//  OnboardingCollectionViewCell.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 5.09.2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    @IBOutlet weak var slideImageView: UIImageView!
    
    @IBOutlet weak var slideTitleLabel: UILabel!
    
    @IBOutlet weak var slideDescLabel: UILabel!
    
    func setup(_ slide: OnboardingSlide){
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescLabel.text = slide.description
    }
    
    
}
