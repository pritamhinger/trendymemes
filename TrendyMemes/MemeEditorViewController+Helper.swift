//
//  MemeEditorViewController+Helper.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 18/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

extension MemeEditorViewController{
    // MARK: - Private Methods
    func applyFilter(selectedFilter:String) {
        if let image = selectedImage.image{
            if let cgImage = image.CGImage{
                let openGLContext = EAGLContext(API: .OpenGLES2)
                let context = CIContext(EAGLContext: openGLContext)
                let coreImage = CIImage(CGImage: cgImage)
                switch selectedFilter {
                case "Sepia":
                    if let output = createAndApplyFilter(coreImage, filterName: "CISepiaTone", filterValue: 1.0, filterImageKey: kCIInputImageKey, filterValueKey: kCIInputIntensityKey, filterOutputKey: kCIOutputImageKey){
                        let cgImageResult = context.createCGImage(output, fromRect: output.extent)
                        let filteredImage = UIImage(CGImage: cgImageResult)
                        selectedImage.image = filteredImage
                    }
                case "Exposure":
                    if let output = createAndApplyFilter(coreImage, filterName: "CIExposureAdjust", filterValue: 1.0, filterImageKey: kCIInputImageKey, filterValueKey: kCIInputEVKey, filterOutputKey: kCIOutputImageKey){
                        let cgImageResult = context.createCGImage(output, fromRect: output.extent)
                        let filteredImage = UIImage(CGImage: cgImageResult)
                        selectedImage.image = filteredImage
                    }
                case "All":
                    if let outputSepia = createAndApplyFilter(coreImage, filterName: "CISepiaTone", filterValue: 1.0, filterImageKey: kCIInputImageKey, filterValueKey: kCIInputIntensityKey, filterOutputKey: kCIOutputImageKey){
                        if let output = createAndApplyFilter(outputSepia, filterName: "CIExposureAdjust", filterValue: 1.0, filterImageKey: kCIInputImageKey, filterValueKey: kCIInputEVKey, filterOutputKey: kCIOutputImageKey){
                            let cgImageResult = context.createCGImage(output, fromRect: output.extent)
                            let filteredImage = UIImage(CGImage: cgImageResult)
                            selectedImage.image = filteredImage
                        }
                    }
                    print("All selected")
                default:
                    selectedImage.image = originalImage
                    print("None Selected")
                }
            }
            else{
                print("Error while applying filter")
                return
            }
        }
    }
    
    func createAndApplyFilter(ciImage:CIImage, filterName:String, filterValue: Float, filterImageKey:String, filterValueKey:String, filterOutputKey: String) -> CIImage?{
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: filterImageKey)
        filter?.setValue(filterValue, forKey: filterValueKey)
        if let output = filter?.valueForKey(filterOutputKey) as? CIImage{
            return output
        }
        else{
            return nil
        }
    }
    
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
    
    func prepareView() {
        saveButton.enabled = false
        filterPopOverBarButton.enabled = false
        templateChooseButton.enabled = false
        fontChooseButton.enabled = false
    }
    
    func prepareViewWithMeme(meme: Meme) {
        textAtTop.text = meme.topTitle
        textAtBottom.text = meme.bottomTitle
        selectedImage.image = meme.originalImage
    }
    
    func enableControls() {
        filterPopOverBarButton.enabled = true
        saveButton.enabled = true
        templateChooseButton.enabled = true
        fontChooseButton.enabled = true
    }
    
    func generateMemedImage() -> UIImage {
        editorToolBar.hidden = true
        pickerToolBar.hidden = true
        view.backgroundColor = UIColor.whiteColor()
        relayoutAsPerTemplate()
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 1.0)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        editorToolBar.hidden = false
        pickerToolBar.hidden = false
        view.backgroundColor = UIColor.darkGrayColor()
        self.memedImage = memedImage
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
        let imageFrame = selectedImage.frame
        
        switch template {
        case .LeftBottom:
            textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(-1 * M_PI/2))
            textAtTop.center = CGPoint(x: imageFrame.origin.x + CGFloat(20), y: imageFrame.origin.y + imageFrame.size.height/2)
        case .BottomRight:
            textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            textAtTop.center = CGPoint(x: imageFrame.size.width - 30, y: imageFrame.origin.y + imageFrame.size.height/2)
        case .LeftRight:
            textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(-1 * M_PI/2))
            textAtTop.center = CGPoint(x: imageFrame.origin.x + CGFloat(20), y: imageFrame.origin.y + imageFrame.size.height/2)
            textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            textAtBottom.center = CGPoint(x: imageFrame.size.width, y: imageFrame.origin.y + imageFrame.size.height/2)
        case .TopLeft:
            textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(-1 * M_PI/2))
            textAtBottom.center = CGPoint(x: imageFrame.origin.x + CGFloat(20), y: imageFrame.origin.y + imageFrame.size.height/2)
        case .TopRight:
            textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            textAtBottom.center = CGPoint(x: imageFrame.size.width, y: imageFrame.origin.y + imageFrame.size.height/2)
        default:
            print("Nothing needs to be changed for Top Bottom Template")
        }
        
    }
    
    func resetLayout() {
        textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(0))
        textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(0))
        let imageCenter = selectedImage.center
        let imageSize = selectedImage.frame.size
        textAtTop.center = CGPoint(x: imageCenter.x, y: imageCenter.y - imageSize.height/2 + CGFloat(23))
        textAtBottom.center = CGPoint(x: imageCenter.x, y: imageCenter.y + imageSize.height/2 - CGFloat(23))
    }
    
    func setUp(textField:UITextField, withText text:String, textAttributes attributes: [String: AnyObject]) {
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .Center
        textField.backgroundColor = UIColor.clearColor()
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        print("Defaut source type is :\(controller.sourceType.rawValue)")
        presentViewController(controller, animated: true, completion: nil)
    }
}