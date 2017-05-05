//
//  Item.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import Foundation

class Item {
    
    var title: String
    var link: String
    var media: String
    var date_taken: Date
    var description: String
    var author: String
    var tags: String
    var width: Int
    var height: Int
    
    init (title: String, link: String, media: String, date_taken: Date, description: String,author: String, tags: String, width: Int, height: Int) {
        
        self.title = title
        self.link = link
        self.media = media
        self.date_taken = date_taken
        self.description = description
        self.author = author
        self.tags = tags
        self.width = width
        self.height = height
    }
}
