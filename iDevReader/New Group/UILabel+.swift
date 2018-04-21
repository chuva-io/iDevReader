//
//  UILabel+.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/20/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text else { return false }
        
        sizeToFit()
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}
