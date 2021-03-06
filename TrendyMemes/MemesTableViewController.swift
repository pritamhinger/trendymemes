//
//  MemesTableViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 17/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {

    // MARK: - Private variables
    private var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.navigationItem.title = "Memes Gallery"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemesTableViewController.reloadTableView(_:)), name: StringConstants.NotificationName.MemeCreatedNotification, object: nil)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.CellIdentifiers.MemeImageTableCellIdentifier, forIndexPath: indexPath) as! MemeGalleryTableViewCell

        let meme = memes[indexPath.row]
        cell.topTitle.text = meme.topTitle
        cell.bottomTitle.text = meme.bottomTitle
        cell.createdDateTime.text = MemeHelper.sharedInstance.getDateStringFromDate(meme.createdDateTime)
        cell.memeImageView.image = meme.memedImage
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            memes.removeAtIndex(indexPath.row)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            NSNotificationCenter.defaultCenter().postNotificationName(StringConstants.NotificationName.MemeCreatedNotification, object: nil)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StringConstants.Segues.MemeTableDetailSegue{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let selectedMeme = memes[indexPath.row]
                let memeDetailVC = segue.destinationViewController as! MemeDetailViewController
                memeDetailVC.meme = selectedMeme
            }
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func createMeme(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(StringConstants.StoryboardId.MemeEditorVC) as! MemeEditorViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    func reloadTableView(notification: NSNotification) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
    }
}
