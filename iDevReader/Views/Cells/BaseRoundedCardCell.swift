//
//  BaseRoundedCardCell.swift
//  iDevReader
//
//  Created by Ivan Corchado Ruiz on 4/5/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

class BaseRoundedCardCell: UITableViewCell {

    fileprivate let kInnerMargin: CGFloat = 16.0
    fileprivate let kCornerRadius: CGFloat = 14.0
    
    fileprivate let shadowView = UIView()
    fileprivate let cornerView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadow()
    }
    
    // MARK: - Shadow
    private func configureShadow() {
        insertSubview(shadowView, at: 0)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: topAnchor, constant: kInnerMargin/2).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -kInnerMargin/2).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: kInnerMargin).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -kInnerMargin).isActive = true
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 4.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.2
        
        shadowView.addSubview(cornerView)
        cornerView.translatesAutoresizingMaskIntoConstraints = false
        cornerView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
        cornerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        cornerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive = true
        cornerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        cornerView.backgroundColor = .white
        cornerView.layer.cornerRadius = kCornerRadius
    }
}
