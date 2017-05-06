//
//  DetailView.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class DetailView: UIView {

    var itemInst: Item!
    var titleLabel = UILabel()
    var itemImageView = UIImageView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.accessibilityLabel = "detailViewInst"
        self.titleLabel.accessibilityLabel = "titleLabel"
        self.titleLabel.textColor = UIColor.black
        
        layoutForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func layoutForm(){

        // itemImageView
        self.addSubview(self.itemImageView)
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false
        self.itemImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 38).isActive = true
        self.itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.itemImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.itemImageView.contentMode = .scaleAspectFit
        self.itemImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // nameLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: 30).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
        self.titleLabel.numberOfLines = 0
    }
}
