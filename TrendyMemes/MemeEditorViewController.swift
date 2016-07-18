//
//  MemeEditorViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 08/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import CoreImage

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var editorToolBar: UIToolbar!
    @IBOutlet weak var pickerToolBar: UIToolbar!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var textAtTop: UITextField!
    @IBOutlet weak var textAtBottom: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var templateChooseButton: UIBarButtonItem!
    @IBOutlet weak var fontChooseButton: UIBarButtonItem!
    @IBOutlet weak var filterPopOverBarButton: UIBarButtonItem!
    
    // MARK: - Private properties
    var memeTextAttributes = [String: AnyObject]()
    var memedImage:UIImage = UIImage()
    var meme:Meme!
    var editMode = false
    var originalImage:UIImage = UIImage()
    
    // MARK: - VC Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let font = userDefaults.valueForKey(StringConstants.DictionaryKeys.FontName) as! String
        memeTextAttributes = getTextFieldParameter(font)
        
        setUp(textAtTop, withText: StringConstants.Default.TextAtTop, textAttributes: memeTextAttributes)
        setUp(textAtBottom, withText: StringConstants.Default.TextAtBottom, textAttributes: memeTextAttributes)
        
        navigationItem.title = "Meme Editor"
        if (meme) != nil{
            prepareViewWithMeme(meme)
            editMode = true
        }
        else{
            prepareView()
        }
        
        subscribeForFontNotification()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.filterChanged(_:)), name: StringConstants.NotificationName.FilterChangeNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeForKeyboardNotification()
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            camera.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeForKeyboardNotification()
    }
    
    // MARK: - IBActions
    @IBAction func pickAnImageFromPhotos(sender: AnyObject) {
        showImagePickerController(.PhotoLibrary)
    }
    
    
    @IBAction func clickANewImage(sender: AnyObject) {
        showImagePickerController(.Camera)
    }
    
    @IBAction func saveMeme(sender: AnyObject) {
        
        if textAtBottom.text == "" || textAtTop.text == ""{
            let alertView = UIAlertController(title: "Nanodegree Assignment", message: "Enter messages to add to image", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil);
            alertView.addAction(defaultAction);
            presentViewController(alertView, animated: true, completion: nil);
            
            if textAtTop.text == ""{
                textAtTop.text = StringConstants.Default.TextAtTop
            }
            else{
                textAtBottom.text = StringConstants.Default.TextAtBottom
            }
            
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityController.excludedActivityTypes = [UIActivityTypeAirDrop,
                                                    UIActivityTypeAddToReadingList,
                                                    UIActivityTypeAssignToContact,
                                                    UIActivityTypePrint,
                                                    UIActivityTypeCopyToPasteboard]
        
        
        activityController.completionWithItemsHandler = {(activityType:String?, completed:Bool, returnedItems: [AnyObject]?, activityError:  NSError?) -> Void in
            if completed {
                let newMeme = Meme(topTitle: self.textAtTop.text!, bottomTitle: self.textAtBottom.text!, originalImage: self.selectedImage.image!, memedImage: self.memedImage, createdDateTime: NSDate())
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(newMeme)
                self.textAtTop.text = StringConstants.Default.TextAtTop
                self.textAtBottom.text = StringConstants.Default.TextAtBottom
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.setValue(StringConstants.Default.Filter, forKey: StringConstants.DictionaryKeys.FilterName)
                
                NSNotificationCenter.defaultCenter().postNotificationName(StringConstants.NotificationName.MemeCreatedNotification, object: nil)
                if self.editMode {
                    NSNotificationCenter.defaultCenter().postNotificationName(StringConstants.NotificationName.DismissDetailViewNotification, object: nil)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            self.resetLayout()
        }
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        selectedImage.image = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showFilters(sender: AnyObject) {
//        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(StringConstants.StoryboardId.ImageFilterViewController) as! ImageFilterViewController
//        controller.modalPresentationStyle = .Popover
//        controller.popoverPresentationController?.sourceView = sender as? UIView
//        controller.popoverPresentationController?.delegate = self
//        presentViewController(controller, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImage.image = image
            originalImage = image
        }
        
        enableControls()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Keyboard Notification Callbacks
    func keyBoardWillShow(notification: NSNotification) {
        if self.textAtBottom.isFirstResponder(){
            self.view.frame.origin.y = -(getKeyboardHeight(notification));
        }
    }
    
    func keyBoardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0.0
    }

    // MARK: - UITextFieldDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1 && textField.text?.uppercaseString == StringConstants.Default.TextAtTop{
            textField.text = ""
        }
        
        if textField.tag == 2 && textField.text?.uppercaseString == StringConstants.Default.TextAtBottom {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filterSegue"{
            let controller = segue.destinationViewController as! ImageFilterViewController
            controller.modalPresentationStyle = UIModalPresentationStyle.Popover
            controller.popoverPresentationController?.delegate = self
        }
        
    }
    
    // MARK: - NSNotification Center Callback Handlers
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func getKeyboardRect(notification: NSNotification) -> CGRect{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue()
    }
    
    func fontUpdated(notification:NSNotification){
        let userInfo = notification.userInfo
        let font = userInfo![StringConstants.DictionaryKeys.FontName] as! String
        print("New font is \(font)")
        memeTextAttributes[NSFontAttributeName] = UIFont(name: font, size: CGFloat(StringConstants.Default.FontSize))
        textAtBottom.defaultTextAttributes = memeTextAttributes
        textAtTop.defaultTextAttributes = memeTextAttributes
        textAtTop.textAlignment = .Center
        textAtBottom.textAlignment = .Center
    }
    
    func filterChanged(notification: NSNotification) {
        let customPayload = notification.userInfo
        let selectedFilter = customPayload![StringConstants.DictionaryKeys.SelectedFilter] as! String?
        if let selectedFilter = selectedFilter{
            applyFilter(selectedFilter)
        }
        
    }
}
