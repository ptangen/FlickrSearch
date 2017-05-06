//
//  SearchResultsView.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit
import SDWebImage

protocol DetailViewDelegate: class {
    func openDetail(item: Item)
    func getFlickrData(searchString: String)
}

class SearchResultsView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let store = DataStore.sharedInstance
    weak var delegate: DetailViewDelegate?
    let searchResultsTableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)

    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: "prototype")
        
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchResultsTableView.tableHeaderView = self.searchController.searchBar
        
        self.pageLayout()
        
        self.accessibilityLabel = "searchResultsViewInst"
        self.searchResultsTableView.accessibilityIdentifier = "searchResultsTableView"
        self.searchResultsTableView.accessibilityLabel = "searchResultsTableView"
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
        
        //        let printFormat = DateFormatter()
        //        printFormat.dateFormat = "MMM dd, yyyy h:mm a"
        //        print("date_taken: \(printFormat.string(from:date_taken! as Date))")
        
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // issue the query to flickr with the search term
        if let searchString = self.searchController.searchBar.text {
            if let delegate = self.delegate {
                delegate.getFlickrData(searchString: searchString)
            }
        }
    }
}
