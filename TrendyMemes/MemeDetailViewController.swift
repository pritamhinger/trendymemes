//
//  MemeDetailViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 17/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme:Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Meme Detail"
        self.memedImage.image = meme.memedImage
    }

    // MARK: - IBActions
    
    @IBAction func editMeme(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(StringConstants.StoryboardId.MemeEditorVC) as! MemeEditorViewController
        controller.meme = meme
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
}
