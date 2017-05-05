//
//  DataStore.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import Foundation

class DataStore {
    
    static let sharedInstance = DataStore()
    fileprivate init() {}
    
    var items = [Item]()
}
