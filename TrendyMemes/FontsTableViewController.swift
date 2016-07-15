//
//  FontsTableViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 10/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class FontsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var fonts = [String: [String]]()
    var familyNames = [String]()
    
    var curSelectedFont = StringConstants.Default.FontName

    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.navigationItem.title = "Select a Font"
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return familyNames.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fonts[familyNames[section]])!.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
 
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return familyNames[section];
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = true
        cell?.accessoryType = .Checkmark
        curSelectedFont = (cell?.textLabel?.text)!
        changeFontName(curSelectedFont)
        
        NSNotificationCenter.defaultCenter().postNotificationName(StringConstants.NotificationName.FontDidChangeNotification, object: nil, userInfo: [StringConstants.DictionaryKeys.FontName:curSelectedFont])
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
        cell?.accessoryType = .None
    }
    
    @IBAction func fontSelected(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Private Methods
    func changeFontName(fontName:String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(fontName, forKey: StringConstants.DictionaryKeys.FontName)
    }
    
}
