//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 13.09.2023.
//

import UIKit
import WebKit


class DetailViewController: UIViewController {
    var articleURL: URL?
    @IBOutlet weak var webView: WKWebView!
    
    var article:Article?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = articleURL {
                            let request = URLRequest(url: url)
                            webView.load(request)
                        }
        

        }
}
    




