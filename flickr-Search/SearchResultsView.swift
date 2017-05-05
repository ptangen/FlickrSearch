//
//  SearchResultsView.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultsView: UIView, UITableViewDataSource, UITableViewDelegate {

    let store = DataStore.sharedInstance
    let searchResultsTableView = UITableView()
    var filteredItems = [Item]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: "prototype")
        
        self.searchController.searchResultsUpdater = self
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count
        }
        return self.store.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! SearchResultsTableViewCell
        var itemCurrent: Item
        if searchController.isActive && searchController.searchBar.text != "" {
            itemCurrent = self.filteredItems[indexPath.row]
        } else {
            itemCurrent = self.store.items[indexPath.row]
        }
        
        // set the title and subtitle
        cell.titleLabel.text = itemCurrent.title
        //cell.subTitleLabel.text = self.store.getCategoryLabelFromID(id: itemCurrent.categoryID)
        
        //        let printFormat = DateFormatter()
        //        printFormat.dateFormat = "MMM dd, yyyy h:mm a"
        //        print("date_taken: \(printFormat.string(from:date_taken! as Date))")
        
        // set the image
        cell.itemImageView.image = nil
        if itemCurrent.media.isEmpty {
            // show no image found
            cell.itemImageView.image = #imageLiteral(resourceName: "noImageFound.jpg")
        } else {
            // show the image per the URL
            let itemImageURL = URL(string: itemCurrent.media)
            cell.itemImageView.sd_setImage(with: itemImageURL)
        }
        cell.itemImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredItems = self.store.items.filter { item in
            return item.title.lowercased().contains(searchText.lowercased())
        }
        self.searchResultsTableView.reloadData()
    }
    
    func pageLayout() {
        
        // myItemsTableView
        self.addSubview(self.searchResultsTableView)
        self.searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.searchResultsTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 64).isActive = true
        self.searchResultsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.searchResultsTableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.searchResultsTableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        // activityIndicator
        //        self.addSubview(self.activityIndicator)
        //        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        //        self.activityIndicatorXConstraintWhileHidden = self.activityIndicator.centerXAnchor.constraint(equalTo: self.leftAnchor, constant: -40)
        //        self.activityIndicatorXConstraintWhileDisplayed = self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        //        self.activityIndicatorXConstraintWhileHidden.isActive = true
        //        self.activityIndicatorXConstraintWhileDisplayed.isActive = false
        //        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        //        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

extension SearchResultsView: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = self.searchController.searchBar.text {
            self.filterContentForSearchText(searchText: searchText)
        }
    }
}
