//
//  MemeEditorViewController.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 08/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var editorToolBar: UIToolbar!
    @IBOutlet weak var pickerToolBar: UIToolbar!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var textAtTop: UITextField!
    @IBOutlet weak var textAtBottom: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Private properties
    var memeTextAttributes = [String: AnyObject]()
    var keyboardShifted = false
    private var textFieldInAction:UITextField?
    
    // MARK: - VC Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let font = userDefaults.valueForKey(StringConstants.DictionaryKeys.FontName) as! String
        memeTextAttributes = getTextFieldParameter(font)
        
        self.textAtTop.delegate = self
        self.textAtTop.text = StringConstants.Default.TextAtTop
        self.textAtTop.defaultTextAttributes = memeTextAttributes
        self.textAtTop.textAlignment = .Center
        self.textAtTop.backgroundColor = UIColor.clearColor()
        
        self.textAtBottom.delegate = self
        self.textAtBottom.textAlignment = .Center
        self.textAtBottom.defaultTextAttributes = memeTextAttributes
        self.textAtBottom.text = StringConstants.Default.TextAtBottom
        self.textAtBottom.backgroundColor = UIColor.clearColor()
        prepareView()
        self.subscribeForFontNotification()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeForKeyboardNotification()
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            camera.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeForKeyboardNotification()
    }
    
    // MARK: - IBActions
    @IBAction func pickAnImageFromPhotos(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func clickANewImage(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func saveMeme(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil);
        self.presentViewController(activityController, animated: true, completion: { () -> Void in
            print("Meme Saved")
        })
    }
    
    @IBAction func cancel(sender: AnyObject) {
        prepareView()
        self.selectedImage.image = nil
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.selectedImage.image = image
        }
        
        enableControls()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Keyboard Notification Callbacks
    func keyBoardWillShow(notification: NSNotification) {
        let textFieldFrame = textFieldInAction?.frame
        let keyboardFrame = getKeyboardRect(notification)
        print(textFieldFrame)
        print(keyboardFrame)
        if (textFieldFrame?.origin.y)! + (textFieldFrame?.height)! < keyboardFrame.origin.y {
            keyboardShifted = false
        }
        else{
            keyboardShifted = true
            self.view.frame.origin.y -= getKeyboardHeight(notification);
        }
    }
    
    func keyBoardWillHide(notification: NSNotification){
        if keyboardShifted{
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    // MARK: - UITextFieldDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        textFieldInAction = textField
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
    
    // MARK: - Private Methods
    func subscribeForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyBoardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyBoardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func subscribeForFontNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.fontUpdated(_:)), name: StringConstants.NotificationName.FontDidChangeNotification, object: nil)
    }
    
    func unsubscribeForKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
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
    
    func prepareView() {
        self.editorToolBar.hidden = true
        self.textAtTop.hidden = true
        self.textAtBottom.hidden = true
    }
    
    func enableControls() {
        self.editorToolBar.hidden = false
        self.textAtTop.hidden = false
        self.textAtBottom.hidden = false
    }
    
    func generateMemedImage() -> UIImage {
        editorToolBar.hidden = true
        pickerToolBar.hidden = true
        relayoutAsPerTemplate()
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        editorToolBar.hidden = false
        pickerToolBar.hidden = false
        let meme = Meme(titleAtTop: self.textAtTop.text!, titleAtBottom: self.textAtBottom.text!, imageToBeMemed: self.selectedImage.image!, memedImage: memedImage)
        self.textAtTop.text = StringConstants.Default.TextAtTop
        self.textAtBottom.text = StringConstants.Default.TextAtBottom
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        NSNotificationCenter.defaultCenter().postNotificationName(StringConstants.NotificationName.MemeCreatedNotification, object: nil)
        return memedImage
    }
    
    func getTextFieldParameter(fontName:String) -> [String : AnyObject]{
        let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: fontName, size: CGFloat(StringConstants.Default.FontSize))!, NSStrokeWidthAttributeName : -3.0]
        return memeTextAttributes
    }
    
    func relayoutAsPerTemplate() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let templateType = userDefault.integerForKey(StringConstants.DictionaryKeys.TemplateType)
        
        let template = TemplateSetting(rawValue: templateType)!
        
        switch template {
        case .LeftBottom:
            print("Left bottom is selected")
            textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            let imageFrame = self.selectedImage.frame
            let imageCoords = imageFrame.origin
            textAtTop.frame.origin = imageCoords
            
        default:
            print("Left bottom is not selected")
        }
        
    }
}
