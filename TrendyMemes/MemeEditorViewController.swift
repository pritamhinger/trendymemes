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
    
    // MARK: - Private properties
    let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "MarkerFelt-Wide", size: 40)!, NSStrokeWidthAttributeName : -3.0]
    var keyboardShifted = false
    private var textFieldInAction:UITextField?
    
    // MARK: - VC Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.selectedImage.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
}
