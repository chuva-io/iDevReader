//
//  ArticleTableViewCell.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/2/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    static let showMoreText = "show more"
    static let showLessText = "show less"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!

}
