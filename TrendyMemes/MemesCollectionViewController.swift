//
//  ViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 07/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Private variables
    private var memes = [Meme]()
    
    // MARK: - Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemSpace = CGFloat(3.0)
        let dimension = (view.frame.size.width - (2 * itemSpace))/3.0
        
        flowLayout.minimumInteritemSpacing = itemSpace
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemesCollectionViewController.reloadCollectionView(_:)), name: StringConstants.NotificationName.MemeCreatedNotification, object: nil)
        self.navigationItem.title = "Memes Gallery"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemesCollectionViewController.screenRotated(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Collection view data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if memes.count == 0{
            showEmptyMessage("No memes created. Click '+' at top right and have fun")
        }
        else{
            showEmptyMessage("")
        }
        
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeImageCellIdentifier" , forIndexPath: indexPath) as! MemeThumbnailCollectionViewCell
        let image = UIImage(named: "placeholder")
        if memes[indexPath.row].topTitle != ""{
            cell.imagePlaceHolder.image = memes[indexPath.row].memedImage
        }
        else{
            cell.imagePlaceHolder.image = image
        }
        
        return cell
    }

    // MARK: - IBActions
    
    @IBAction func createMeme(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(StringConstants.StoryboardId.MemeEditorVC) as! MemeEditorViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StringConstants.Segues.MemeCollectionDetailSegue{
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let selectedMeme = memes[indexPath!.row]
            let memeDetailVC = segue.destinationViewController as! MemeDetailViewController
            memeDetailVC.meme = selectedMeme
        }
    }
    
    // MARK: - Private Methods
    func reloadCollectionView(notification: NSNotification) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        collectionView.reloadData()
    }
    
    func showEmptyMessage(message:String) -> Void{
        let frame:CGRect = CGRect(x: 40, y: 0, width: (collectionView.bounds.size.width - 80), height: collectionView.bounds.size.height);
        
        let emptyLabel:UILabel = UILabel(frame: frame);
        
        emptyLabel.text = message;
        emptyLabel.textColor = UIColor.orangeColor();
        emptyLabel.numberOfLines = 0;
        emptyLabel.textAlignment = NSTextAlignment.Center;
        let font:UIFont = UIFont(name: "AvenirNext-MediumItalic", size: 20)!
        emptyLabel.font = font;
        emptyLabel.sizeToFit();
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let leading = NSLayoutConstraint(item: emptyLabel, attribute: .Leading, relatedBy: .Equal, toItem: collectionView, attribute: .Leading, multiplier: 1, constant: 15)
        let yConstraint = NSLayoutConstraint(item: emptyLabel, attribute: .Trailing, relatedBy: .Equal, toItem: collectionView, attribute: .Trailing, multiplier: 1, constant: 15)
        let centerY = NSLayoutConstraint(item: emptyLabel, attribute: .CenterY, relatedBy: .Equal, toItem: collectionView, attribute: .CenterY, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint(item: emptyLabel, attribute: .CenterX, relatedBy: .Equal, toItem: collectionView, attribute: .CenterX, multiplier: 1, constant: 0)
        collectionView.backgroundView = emptyLabel;
        collectionView.addConstraint(leading);
        collectionView.addConstraint(yConstraint);
        collectionView.addConstraint(centerY);
        collectionView.addConstraint(centerX);
    }
    
    func screenRotated(notification:NSNotification) {
        let itemSpace = CGFloat(3.0)
        let dimension = (view.frame.size.width - (2 * itemSpace))/3.0
        
        flowLayout.minimumInteritemSpacing = itemSpace
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait")
        }
    }
}

