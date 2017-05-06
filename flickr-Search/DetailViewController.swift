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
        self.title = "Image Details" // nav bar title

        let itemImageURL = URL(string: self.detailViewInst.itemInst.media)
        self.detailViewInst.itemImageView.sd_setImage(with: itemImageURL)
        self.detailViewInst.layoutForm()
        
        self.detailViewInst.titleTextView.text = self.detailViewInst.itemInst.title + "\n\n" + self.detailViewInst.itemInst.description
        self.detailViewInst.dimensionsLabel.text = String(self.detailViewInst.itemInst.width) + " x " + String(self.detailViewInst.itemInst.height)
        
        let printDateFormat = DateFormatter()
        printDateFormat.dateFormat = "MMM dd, yyyy"
        self.detailViewInst.dateLabel.text = printDateFormat.string(from:self.detailViewInst.itemInst.date_taken as Date)
        
        let printTimeFormat = DateFormatter()
        printTimeFormat.dateFormat = "h:mm a"
        self.detailViewInst.timeLabel.text = printTimeFormat.string(from:self.detailViewInst.itemInst.date_taken as Date)
    }
}
