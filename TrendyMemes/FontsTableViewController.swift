//
//  FontsTableViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 10/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class FontsTableViewController: UITableViewController {
    
    var fonts = [String: [String]]()
    var familyNames = [String]()
    
    var curSelectedFont = StringConstants.Default.FontName

    override func viewDidLoad() {
        super.viewDidLoad()

        fonts = FontsManager.sharedInstance.fonts
        familyNames = Array(fonts.keys)
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let fontName = userDefault.valueForKey(StringConstants.DictionaryKeys.FontName){
            curSelectedFont = fontName as! String
            print(curSelectedFont)
        }
        else{
            curSelectedFont = StringConstants.Default.FontName
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return familyNames.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fonts[familyNames[section]])!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.CellIdentifiers.FontFamilyNameCellIdentifier, forIndexPath: indexPath)
        
        let fontName = (fonts[familyNames[indexPath.section]])![indexPath.row]
        cell.textLabel?.text = fontName
        
        if fontName == curSelectedFont{
            cell.selected = true
            cell.accessoryType = .Checkmark
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
        }
        else{
            cell.accessoryType = .None
        }
        
        return cell
    }
 
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return familyNames[section];
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = true
        cell?.accessoryType = .Checkmark
        curSelectedFont = (cell?.textLabel?.text)!
        changeFontName(curSelectedFont)
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
        if segue.identifier == StringConstants.Segues.ShowFontsSegue{
            let destinationController = segue.destinationViewController as! FontDetailTableViewController
            let currentCell = sender as! UITableViewCell
            let currentFontFamily = currentCell.textLabel?.text
            destinationController.fonts = fonts[currentFontFamily!]!
        }
    }
    */
    
    // MARK: - Private Methods
    func changeFontName(fontName:String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(fontName, forKey: StringConstants.DictionaryKeys.FontName)
    }
    
}
