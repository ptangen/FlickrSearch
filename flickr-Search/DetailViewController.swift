//
//  DetailViewController.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    var detailViewInst = DetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []   // prevents view from siding under nav bar
    }
    
    override func loadView(){
        self.navigationController?.setNavigationBarHidden(false, animated: .init(true))
        self.detailViewInst.frame = CGRect.zero
        self.view = self.detailViewInst
        self.navigationController?.navigationBar.backItem?.title = "" // results in a back button label of "<"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Item Detail" // nav bar title

        let itemImageURL = URL(string: self.detailViewInst.itemInst.media)
        self.detailViewInst.itemImageView.sd_setImage(with: itemImageURL)
        
        self.detailViewInst.titleLabel.text = self.detailViewInst.itemInst.title
    }
}
