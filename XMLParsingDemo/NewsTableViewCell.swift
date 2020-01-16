//
//  NewsTableViewCell.swift
//  XMLParsingDemo
//
//  Created by Sandeep Kakde on 01/12/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
