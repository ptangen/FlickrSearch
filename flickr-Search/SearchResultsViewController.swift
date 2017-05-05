//
//  SearchResultsViewController.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    let store = DataStore.sharedInstance
    var searchResultsViewInst = SearchResultsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        APIClient.searchFlicker(tags: "") { isSuccessful in
            if isSuccessful {
                OperationQueue.main.addOperation {
                    // reload tableview to show search results
                    self.searchResultsViewInst.searchResultsTableView.reloadData()
                    //viewController.myItemsViewInst.activityIndicatorXConstraintWhileDisplayed.isActive = false
                    //viewController.myItemsViewInst.activityIndicatorXConstraintWhileHidden.isActive = true
                }
            } else {
                OperationQueue.main.addOperation {
                    // show error message in the current view
                    let message = "Unable to retrieve data from the server."
                    
                    //self.searchResultsViewInst.activityIndicatorXConstraintWhileDisplayed.isActive = false
                    //self.searchResultsViewInst.activityIndicatorXConstraintWhileHidden.isActive = true
                    self.showAlertMessage(message)
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
    
    //    func openItemDetail(item: MyItem) {
    //        let itemDetailViewControllerInst = ItemDetailViewController()
    //        itemDetailViewControllerInst.itemInst = item
    //        self.navigationController?.pushViewController(itemDetailViewControllerInst, animated: false)
    //    }
    
    func showAlertMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
