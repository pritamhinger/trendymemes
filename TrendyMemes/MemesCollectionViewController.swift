//
//  ViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 07/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    private var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("memeImageCellIdentifier" , forIndexPath: indexPath) as! MemeThumbnailCollectionViewCell
        let image = UIImage(named: "placeholder")
        
        cell.imagePlaceHolder.image = image
        
        return cell
    }

}

