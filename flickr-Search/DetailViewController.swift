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
        // hide nav bar on login page
        self.navigationController?.setNavigationBarHidden(false, animated: .init(true))
        self.detailViewInst.frame = CGRect.zero
        self.view = self.detailViewInst
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
