//
//  SavedDetailViewController.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 16.09.2023.
//

import UIKit
import WebKit

class SavedDetailViewController: UIViewController {

    @IBOutlet weak var savedWebView: WKWebView!
    var newsURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: newsURL ?? "") {
                            let request = URLRequest(url: url)
                            savedWebView.load(request)
                        }

        // Do any additional setup after loading the view.
    }
    
}
