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
        self.itemImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.itemImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.itemImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        //titleLabel
        contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: 10).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
    }
}
