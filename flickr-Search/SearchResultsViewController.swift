//
//  SearchResultsViewController.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, DetailViewDelegate {

    let store = DataStore.sharedInstance
    var searchResultsViewInst = SearchResultsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultsViewInst.delegate = self
        self.definesPresentationContext = true // hides search bar after navigating away
        
        // fetch the initial set of images from flickr
        self.getFlickrData(searchString: "")
    }
    
    func getFlickrData(searchString:String) {
        
        APIClient.searchFlickr(tags: searchString) { response in
            if response == "success" {
                OperationQueue.main.addOperation {
                    // reload tableview to show search results
                    self.searchResultsViewInst.searchResultsTableView.reloadData()
                }
            } else if response == "invalidJSON" {
                // invalid JSON is fairly rare, if we get invalid JSON, reissue the query
                print("invalid JSON received from flickr, reissue the query")
                self.getFlickrData(searchString: searchString)
                
            } else if response == "noItemsFound" {
                let title = "No Items Found"
                let message = "flickr did not have any images that matched your search terms."
                self.showAlertMessage(title: title, message: message)
                
            } else { // error
                OperationQueue.main.addOperation {
                    // show error message in the current view
                    let title = "Error"
                    let message = "Unable to retrieve data from the server."
                    self.showAlertMessage(title: title, message: message)
                }
            }
        }
    }
    
    override func loadView(){
        // hide nav bar on login page
        self.navigationController?.setNavigationBarHidden(false, animated: .init(true))
        self.searchResultsViewInst.frame = CGRect.zero
        self.view = self.searchResultsViewInst
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "flickr Search"
    }
    
    func openDetail(item: Item) {
        let detailViewControllerInst = DetailViewController()
        detailViewControllerInst.detailViewInst.itemInst = item
        self.navigationController?.pushViewController(detailViewControllerInst, animated: false)
    }
    
    func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        if presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        } else{
            self.dismiss(animated: false) { () -> Void in
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
