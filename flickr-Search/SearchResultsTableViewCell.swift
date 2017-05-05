//
//  SearchResultsTableViewCell.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    let itemImageView = UIImageView()
    var titleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.titleLabel.accessibilityIdentifier = "titleLabel"
        self.cellLayout()
    }
    
    func cellLayout() {
        
        //itemImageView
        contentView.addSubview(self.itemImageView)
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false
        self.itemImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        self.itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        self.itemImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        self.itemImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //titleLabel
        contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -2).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.itemImageView.rightAnchor, constant: 6).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
}
