//
//  SearchResultsView.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit
import SDWebImage

protocol SearchResultsViewDelegate: class {
    func openDetail(item: Item)
    func getFlickrData(searchString: String)
}

class SearchResultsView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let store = DataStore.sharedInstance
    weak var delegate: SearchResultsViewDelegate?
    let searchResultsTableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let getSearchResultsButtonForUITest = UIButton()

    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: "prototype")
        self.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchResultsTableView.tableHeaderView = self.searchController.searchBar
        
        self.getSearchResultsButtonForUITest.addTarget(self, action: #selector(getSearchResults), for: UIControlEvents.touchUpInside)
        
        self.pageLayout()
        
        self.accessibilityLabel = "searchResultsViewInst"
        self.searchResultsTableView.accessibilityIdentifier = "searchResultsTableView"
        self.searchResultsTableView.accessibilityLabel = "searchResultsTableView"
        self.searchController.searchBar.accessibilityLabel = "searchField"
        self.getSearchResultsButtonForUITest.accessibilityLabel = "getSearchResultsButtonForUITest"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // tableview config
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        // we want to fill the cell with the image, so we get the multipler needed to fill the width
        // then apply the multiplier to the height, then set contentMode = .scaleAspectFit
        
        let imageWidth = self.store.items[indexPath.row].width
        let multiplier = self.frame.width/CGFloat(imageWidth)
        
        let cellHeight = CGFloat(self.store.items[indexPath.row].height) * multiplier
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! SearchResultsTableViewCell
        var itemCurrent: Item
        itemCurrent = self.store.items[indexPath.row]

        // set the title and dimensions
        cell.titleLabel.text = itemCurrent.title
        cell.dimensionLabel.text = "(" + String(itemCurrent.width) + " x " + String(itemCurrent.height) + ")"
        
        // set the image
        cell.itemImageView.image = nil
        let itemImageURL = URL(string: itemCurrent.media)
        cell.itemImageView.sd_setImage(with: itemImageURL)
        cell.itemImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openDetail(item: self.store.items[indexPath.row])
    }
    
    func pageLayout() {
        
        // myItemsTableView
        self.addSubview(self.searchResultsTableView)
        self.searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.searchResultsTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.searchResultsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.searchResultsTableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.searchResultsTableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        // getSearchResultsButtonForUITest
        self.addSubview(self.getSearchResultsButtonForUITest)
        self.getSearchResultsButtonForUITest.translatesAutoresizingMaskIntoConstraints = false
        self.getSearchResultsButtonForUITest.topAnchor.constraint(equalTo: self.topAnchor, constant: 31).isActive = true
        self.getSearchResultsButtonForUITest.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        // the button has no label or background color so it cant be seen in the upper left corner of the search bar.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // issue the query to flickr with the search term
        if let searchString = self.searchController.searchBar.text {
            if let delegate = self.delegate {
                delegate.getFlickrData(searchString: searchString)
            }
        }
    }
    
    func getSearchResults () {
        // used by the UI test
        self.searchBarSearchButtonClicked(self.searchController.searchBar)
    }
}
