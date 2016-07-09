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
        //tableView.deselectRowAtIndexPath(curSeletedIndex, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = true
        cell?.accessoryType = .Checkmark
        //changeTemplate(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
        cell?.accessoryType = .None
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
