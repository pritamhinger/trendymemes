//
//  ImageFilterViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 17/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class ImageFilterViewController: UIViewController {

    @IBOutlet weak var filterType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var selectedFilter = StringConstants.Default.Filter
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let fontName = userDefault.valueForKey(StringConstants.DictionaryKeys.FilterName){
            selectedFilter = fontName as! String
        }
        
        filterType.selectedSegmentIndex = UISegmentedControlNoSegment
        if selectedFilter == "None"{
            filterType.selectedSegmentIndex = 0
        }
        else if selectedFilter == "Sepia"{
            filterType.selectedSegmentIndex = 1
        }
        else if selectedFilter == "Exposure"{
            filterType.selectedSegmentIndex = 2
        }
        else{
            filterType.selectedSegmentIndex = 3
        }
    }
        
    
    @IBAction func filterChanged(sender: AnyObject) {
        let filterControl = sender as! UISegmentedControl
        let selectedFilter = filterControl.titleForSegmentAtIndex(filterControl.selectedSegmentIndex)
        changeFilter(selectedFilter!)
        NSNotificationCenter.defaultCenter().postNotificationName(StringConstants.NotificationName.FilterChangeNotification, object: nil, userInfo: [StringConstants.DictionaryKeys.SelectedFilter:selectedFilter!])
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeFilter(filterName:String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(filterName, forKey: StringConstants.DictionaryKeys.FilterName)
    }
}
