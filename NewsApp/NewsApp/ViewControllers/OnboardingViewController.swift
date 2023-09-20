//
//  OnboardingViewController.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 5.09.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!

    private var slides: [OnboardingSlide] = []
    private var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        slides = [
            OnboardingSlide(title: "GET NEWS EVERYWHERE", description: "Now sign up and up to date news app in your hands wherever you go!", image: UIImage(named: "001-newspaper")),
            OnboardingSlide(title: "STAY IN THE KNOW WITH JUST ONE TAP", description: "Easily stay informed and up-to-date on the latest news about your interest!", image: UIImage(named: "election")),
            OnboardingSlide(title: "SAVE YOUR FAVORITE NEWS", description: "Access your saved news with just one tap!", image: UIImage(named: "bookmark"))
        ]

        collectionView.delegate = self
        collectionView.dataSource = self

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = currentPage
        updateNextButtonTitle()
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        if currentPage == slides.count - 1 {
            UserDefaults.standard.hasOnboarded = true
            navigateToHomeScreen()
        } else {
            currentPage += 1
            scrollToCurrentPage()
            updateNextButtonTitle()
        }
    }

    private func navigateToHomeScreen() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "startNC") as! UINavigationController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        present(controller, animated: true, completion: nil)
    }

    private func scrollToCurrentPage() {
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func updateNextButtonTitle() {
        if currentPage == slides.count - 1 {
            nextButton.setTitle("Get Started", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        let slide = slides[indexPath.item]
        cell.setup(slide)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
        updateNextButtonTitle()
    }
}
