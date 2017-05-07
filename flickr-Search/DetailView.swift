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
    var titleTextView = UITextView()
    var dateLabel = UILabel()
    var timeLabel = UILabel()
    var dimensionsLabel = UILabel()
    var itemImageView = UIImageView()
    var grayBarView = UIView()
    
    override init(frame:CGRect){
        super.init(frame: frame)

        self.titleTextView.textColor = UIColor.black
        self.titleTextView.isEditable = false
        self.titleTextView.font = UIFont.systemFont(ofSize: 20)
        self.timeLabel.textColor = UIColor.lightGray
        self.dateLabel.textColor = UIColor.lightGray
        self.dimensionsLabel.textColor = UIColor.lightGray
        self.grayBarView.backgroundColor = UIColor.darkGray
        
        self.accessibilityLabel = "detailViewInst"
        self.titleTextView.accessibilityLabel = "titleTextView"
        self.dateLabel.accessibilityLabel = "dateLabel"
        self.timeLabel.accessibilityLabel = "timeLabel"
        self.dimensionsLabel.accessibilityLabel = "dimensionsLabel"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func layoutForm(){
        
        if let itemInst = self.itemInst {
            
            // grayBarView
            self.addSubview(self.grayBarView)
            self.grayBarView.translatesAutoresizingMaskIntoConstraints = false
            
            // itemImageView
            self.addSubview(self.itemImageView)
            self.itemImageView.translatesAutoresizingMaskIntoConstraints = false
            self.itemImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            self.itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            self.itemImageView.contentMode = .scaleAspectFit
            
            // dateLabel
            self.addSubview(self.dateLabel)
            self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
            self.dateLabel.textAlignment = .right
            
            // timeLabel
            self.addSubview(self.timeLabel)
            self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
            self.timeLabel.textAlignment = .right
            
            // dimensionsLabel
            self.addSubview(self.dimensionsLabel)
            self.dimensionsLabel.translatesAutoresizingMaskIntoConstraints = false
            self.dimensionsLabel.textAlignment = .right
            
            // titleLabel
            self.addSubview(self.titleTextView)
            self.titleTextView.translatesAutoresizingMaskIntoConstraints = false
            self.titleTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
            self.titleTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
            self.titleTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            
            // change the layout based on the width of the image
            if itemInst.width > 200 {
                let width = CGFloat(itemInst.width) // as CGFloat
                let multiplier = UIScreen.main.bounds.width/width
                let imageHeight = CGFloat(itemInst.height) * multiplier
                
                // itemImageView
                self.itemImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
                self.itemImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
                
                // grayBarView
                self.grayBarView.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: -1).isActive = true
                self.grayBarView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                self.grayBarView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                self.grayBarView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                
                // timeLabel
                self.timeLabel.topAnchor.constraint(equalTo: self.grayBarView.topAnchor, constant: 6).isActive = true
                self.timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
                
                // dateLabel
                self.dateLabel.topAnchor.constraint(equalTo: self.grayBarView.topAnchor, constant: 6).isActive = true
                self.dateLabel.rightAnchor.constraint(equalTo: self.timeLabel.leftAnchor, constant: -6).isActive = true
                
                // dimensionsLabel
                self.dimensionsLabel.topAnchor.constraint(equalTo: self.grayBarView.topAnchor, constant: 6).isActive = true
                self.dimensionsLabel.leftAnchor.constraint(equalTo: self.grayBarView.leftAnchor, constant: 6).isActive = true
                
                // titleTextView
                self.titleTextView.topAnchor.constraint(equalTo: self.grayBarView.bottomAnchor, constant: 20).isActive = true
                
            } else { // width is less than 200, place these label to the right of the image
                
                // grayBarView
                self.grayBarView.centerYAnchor.constraint(equalTo: self.itemImageView.centerYAnchor, constant: 0).isActive = true
                self.grayBarView.leftAnchor.constraint(equalTo: self.itemImageView.centerXAnchor).isActive = true
                self.grayBarView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                self.grayBarView.heightAnchor.constraint(equalToConstant: 96.0).isActive = true
                
                // dimensionsLabel
                self.dimensionsLabel.bottomAnchor.constraint(equalTo: self.itemImageView.centerYAnchor, constant: -12).isActive = true
                self.dimensionsLabel.leftAnchor.constraint(equalTo: self.itemImageView.rightAnchor, constant: 6).isActive = true
                
                // dateLabel
                self.dateLabel.centerYAnchor.constraint(equalTo: self.itemImageView.centerYAnchor, constant: 0).isActive = true
                self.dateLabel.leftAnchor.constraint(equalTo: self.itemImageView.rightAnchor, constant: 6).isActive = true
                
                // timeLabel
                self.timeLabel.topAnchor.constraint(equalTo: self.itemImageView.centerYAnchor, constant: 14).isActive = true
                self.timeLabel.leftAnchor.constraint(equalTo: self.itemImageView.rightAnchor, constant: 6).isActive = true
                
                // titleTextView
                self.titleTextView.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: 20).isActive = true
            }
            
        }
    }
}
