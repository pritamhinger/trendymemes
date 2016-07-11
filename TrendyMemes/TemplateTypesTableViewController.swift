//
//  TemplateTypesTableViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 09/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class TemplateTypesTableViewController: UITableViewController {

    var currentTemplate = TemplateSetting.TopBottom
    //var curSeletedIndex:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let templateSetting = userDefaults.valueForKey(StringConstants.DictionaryKeys.TemplateType){
            currentTemplate = TemplateSetting(rawValue: templateSetting as! Int)!
        }
        
        self.navigationItem.title = "Select a Template"
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.CellIdentifiers.TemplateTypeCellIdentifier, forIndexPath: indexPath) 
        
        let template = TemplateSetting(rawValue: indexPath.row)
        let templateDetail = getTemplateDetails(template!)
        
        if currentTemplate == template{
            cell.selected = true
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            cell.accessoryType = .Checkmark
        }
        
        cell.textLabel?.text = templateDetail.0
        cell.detailTextLabel?.text = templateDetail.1
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = true
        cell?.accessoryType = .Checkmark
        changeTemplate(indexPath.row)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
        cell?.accessoryType = .None
    }

    // MARK: - Private Methods
    func getTemplateDetails(template:TemplateSetting) -> (String, String) {
        switch template {
        case .TopBottom:
            return ("Top & Bottom", "Message would be placed at top and bottom of Image")
        case .TopLeft:
            return ("Top & Left", "Message would be placed at top and left of Image")
        case .TopRight:
            return ("Top & Right", "Message would be placed at top and right of Image")
        case .LeftRight:
            return ("Left & Right", "Message would be placed at left and right of Image")
        case .LeftBottom:
            return ("Left & Bottom", "Message would be placed at left and bottom of Image")
        case .BottomRight:
            return ("Bottom & Right", "Message would be placed at bottom and right of Image")
        }
    }
    
    func changeTemplate(templateId:Int) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(templateId, forKey: StringConstants.DictionaryKeys.TemplateType)
    }
}
