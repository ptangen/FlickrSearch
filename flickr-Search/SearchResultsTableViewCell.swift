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
    var dimensionLabel = UILabel()
    var gradientView = GradientView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.titleLabel.textColor = UIColor.lightGray
        self.dimensionLabel.textColor = UIColor.lightGray
        
        self.cellLayout()
        
        self.titleLabel.accessibilityIdentifier = "titleLabel"
        self.dimensionLabel.accessibilityIdentifier = "dimensionLabel"
        
    }
    
    func cellLayout() {
        
        //itemImageView
        contentView.addSubview(self.itemImageView)
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false
        self.itemImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.itemImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.itemImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        //gradientView
        self.gradientView = GradientView(frame: itemImageView.frame)
        self.gradientView.layer.masksToBounds = true
        self.contentView.addSubview(gradientView)
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.gradientView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.gradientView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.gradientView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.gradientView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        //dimensionLabel
        contentView.addSubview(self.dimensionLabel)
        self.dimensionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dimensionLabel.bottomAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: -10).isActive = true
        //self.dimensionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.dimensionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        
        //titleLabel
        contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.bottomAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: -10).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.dimensionLabel.leftAnchor, constant: -3).isActive = true
    }
}
