//
//  OnboardingViewModel.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 19.09.2023.
//

import UIKit

class OnboardingViewModel {
    private var slides: [OnboardingSlide] = []



    func numberOfSlides() -> Int {
        return slides.count
    }

    func slide(at index: Int) -> OnboardingSlide {
        guard index >= 0, index < slides.count else {
            fatalError("Invalid slide index")
        }
        return slides[index]
    }
}
