//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 12.09.2023.
//

import UIKit
protocol CellProtocol {
    func detailBtnTapped(indexPath:IndexPath)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with article: Article) {
        newsTitleLabel.text = article.title

        if let imageURLString = article.urlToImage, let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if error != nil {
                    print("Image load error: (error.localizedDescription)")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.newsImageView.image = image
                    }
                }
            }.resume()
        }
    }
    var cellProtocol:CellProtocol?
    var indexPath:IndexPath?
    
    @IBAction func detailBtnClicked(_ sender: Any) {
        cellProtocol?.detailBtnTapped(indexPath: indexPath!)
    }
}
