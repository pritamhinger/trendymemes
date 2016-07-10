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
    
    // MARK: - Private variables
    private var memes = [Meme]()
    
    // MARK: - Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemesCollectionViewController.reloadCollectionView(_:)), name: StringConstants.NotificationName.MemeCreatedNotification, object: nil)
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
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("memeImageCellIdentifier" , forIndexPath: indexPath) as! MemeThumbnailCollectionViewCell
        let image = UIImage(named: "placeholder")
        if memes[indexPath.row].topTitle != ""{
            cell.imagePlaceHolder.image = memes[indexPath.row].memedImage
        }
        else{
            cell.imagePlaceHolder.image = image
        }
        
        return cell
    }

    // MARK: - Private Methods
    func reloadCollectionView(notification: NSNotification) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.collectionView.reloadData()
    }
    
    func showEmptyMessage(message:String) -> Void{
        let frame:CGRect = CGRect(x: 40, y: 0, width: (self.collectionView.bounds.size.width - 80), height: self.collectionView.bounds.size.height);
        
        let emptyLabel:UILabel = UILabel(frame: frame);
        
        emptyLabel.text = message;
        emptyLabel.textColor = UIColor.orangeColor();
        emptyLabel.numberOfLines = 0;
        emptyLabel.textAlignment = NSTextAlignment.Center;
        let font:UIFont = UIFont(name: "AvenirNext-MediumItalic", size: 20)!
        emptyLabel.font = font;
        emptyLabel.sizeToFit();
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let leading = NSLayoutConstraint(item: emptyLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.collectionView, attribute: .Leading, multiplier: 1, constant: 15)
        let yConstraint = NSLayoutConstraint(item: emptyLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.collectionView, attribute: .Trailing, multiplier: 1, constant: 15)
        let centerY = NSLayoutConstraint(item: emptyLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.collectionView, attribute: .CenterY, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint(item: emptyLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.collectionView, attribute: .CenterX, multiplier: 1, constant: 0)
        self.collectionView.backgroundView = emptyLabel;
        self.collectionView.addConstraint(leading);
        self.collectionView.addConstraint(yConstraint);
        self.collectionView.addConstraint(centerY);
        self.collectionView.addConstraint(centerX);
    }
}

