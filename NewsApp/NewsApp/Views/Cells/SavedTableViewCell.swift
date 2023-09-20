//
//  SavedTableViewCell.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 14.09.2023.
//

import UIKit

class SavedTableViewCell: UITableViewCell {

    @IBOutlet weak var savedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showSavedNews(url: String) {
                savedLabel.text = url
                
            }

}
