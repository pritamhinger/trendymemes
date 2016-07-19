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
    // Below method apply the Selected filter to the choosen image.
    // Please note here that i have followed the following code from AppCoda.com but i have refractored the code to better suit 
    // my problem statement
    func applyFilter(selectedFilter:String) {
        
        // Getting the selected image
        if let image = selectedImage.image{
            if let cgImage = image.CGImage{
                let openGLContext = EAGLContext(API: .OpenGLES2)
                let context = CIContext(EAGLContext: openGLContext)
                let coreImage = CIImage(CGImage: cgImage)
                
                // Below function createAndApplyFilter is actual code where i did refractoring.
                // Since most of the properties to aply filter follow common code so i took out a function from it.
                // This refactoring helped particularly in chaining Applying of Filter
                switch selectedFilter {
                case "Sepia":
                    if let output = createAndApplyFilter(coreImage, filterName: "CISepiaTone", filterValue: 1.0, filterValueKey: kCIInputIntensityKey){
                        let cgImageResult = context.createCGImage(output, fromRect: output.extent)
                        let filteredImage = UIImage(CGImage: cgImageResult)
                        selectedImage.image = filteredImage
                    }
                case "Exposure":
                    if let output = createAndApplyFilter(coreImage, filterName: "CIExposureAdjust", filterValue: 1.0, filterValueKey: kCIInputEVKey){
                        let cgImageResult = context.createCGImage(output, fromRect: output.extent)
                        let filteredImage = UIImage(CGImage: cgImageResult)
                        selectedImage.image = filteredImage
                    }
                case "All":
                    // Chaining Multiple Filters.
                    // Passing output of one filter into another filter
                    if let outputSepia = createAndApplyFilter(coreImage, filterName: "CISepiaTone", filterValue: 1.0, filterValueKey: kCIInputIntensityKey){
                        if let output = createAndApplyFilter(outputSepia, filterName: "CIExposureAdjust", filterValue: 1.0, filterValueKey: kCIInputEVKey){
                            let cgImageResult = context.createCGImage(output, fromRect: output.extent)
                            let filteredImage = UIImage(CGImage: cgImageResult)
                            selectedImage.image = filteredImage
                        }
                    }
                default:
                    // If none is selected then we will reset the selected image using reference to original image which is created when image is choosen
                    // using ImagePickerController
                    selectedImage.image = originalImage
                }
            }
            else{
                // Failed to get CGImage to apply filter
                print("Error while applying filter ==>> Image not present")
                return
            }
        }
    }
    
    /**
     This function apply the filter and return updated image. The filter object is calculated based on passed parameter.
     
     - Parameter ciImage: The ciImage object of input image.
     - Parameter filterName: Name of the filter to be applied.
     - Parameter filterValue: The amount of filter value to be applied. Used to control the amount of filter applied.
     - Parameter filterValueKey: Key for which the filterValue is to be applied.
     - Returns: Filtered Image if filter applied successfully or nil.
     
     */
    func createAndApplyFilter(ciImage:CIImage, filterName:String, filterValue: Float, filterValueKey:String) -> CIImage?{
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(filterValue, forKey: filterValueKey)
        if let output = filter?.valueForKey(kCIOutputImageKey) as? CIImage{
            return output
        }
        else{
            return nil
        }
    }
    
    /**
    Subscribe for Keyboard visibility change notification
    */
    func subscribeForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyBoardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyBoardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     Subscribe for Font change notification
     */
    func subscribeForFontNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.fontUpdated(_:)), name: StringConstants.NotificationName.FontDidChangeNotification, object: nil)
    }
    
    /**
     Unsubscribe Keyboard visibility change notification
     */
    func unsubscribeForKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     Set the view controller for first time load.
     
     ## What is done here:
        * Disable Save Button
        * Disable Filter Button
        * Disable button to choose template
        * Diable button to choose fonts
     */
    func prepareView() {
        saveButton.enabled = false
        filterPopOverBarButton.enabled = false
        templateChooseButton.enabled = false
        fontChooseButton.enabled = false
    }
    
    /**
     Set the view controller when MemeEditor View Controller opens up in Edit Mode
     
     ## What is done here:
        * Set Text in Textfiled at Top
        * Set Text in Textfield at Bottom
        * Set Original Image in ImageView for editing
     */
    func prepareViewWithMeme(meme: Meme) {
        textAtTop.text = meme.topTitle
        textAtBottom.text = meme.bottomTitle
        selectedImage.image = meme.originalImage
    }
    
    /**
     Enable all the disable controls on Editor Toolbar
     */
    func enableControls() {
        filterPopOverBarButton.enabled = true
        saveButton.enabled = true
        templateChooseButton.enabled = true
        fontChooseButton.enabled = true
    }
    
    /**
     Capture screenshot with text and save image with text in textfields to generate Meme
     */
    func generateMemedImage() -> UIImage {
        
        // Hidding Editor and Image Picker Toolbar so as to not capture them in screenshot
        editorToolBar.hidden = true
        pickerToolBar.hidden = true
        
        // Setting background color of view to be white
        view.backgroundColor = UIColor.whiteColor()
        
        // Relayouting textfields as per the template selected
        relayoutAsPerTemplate()
        
        //Preparing to take sceenshot programatically
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 1.0)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Screenshot taken in above line
        
        // Showing Editor and Image Picker toolbar again
        editorToolBar.hidden = false
        pickerToolBar.hidden = false
        
        // Setting background color of view to Dark Gray
        view.backgroundColor = UIColor.darkGrayColor()
        
        // Setting screenshot captured above to the instance variable for saving in UIActivityViewController Completion Closure
        self.memedImage = memedImage
        
        // Returning MemedImage/Screenshot to UIActivityViewController
        return memedImage
    }
    
    /**
     Helper method to create TextAttributes to be applied to TextFileds.
     - Parameter fontName: Name of the font to be used in textfield
     - Remark:
            Refactored code so that all textfields styles can be changed from single place in code.
            Also, passed on fontName so that User can chose his favorite Font for Meme Text
     */
    func getTextFieldParameter(fontName:String) -> [String : AnyObject]{
        let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: fontName, size: CGFloat(StringConstants.Default.FontSize))!, NSStrokeWidthAttributeName : -3.0]
        return memeTextAttributes
    }
    
    /**
     Set textfield as per the chosen template.
     */
    func relayoutAsPerTemplate() {
        // Fetching the selected Template from UserDefault Dictionary
        let userDefault = NSUserDefaults.standardUserDefaults()
        let templateType = userDefault.integerForKey(StringConstants.DictionaryKeys.TemplateType)
        
        let template = TemplateSetting(rawValue: templateType)!
        let imageFrame = selectedImage.frame
        
        switch template {
        case .LeftBottom:
            // If selected template is Left and Bottom then we would change center of Top TextField to Left Edge and transform
            // it by -90 degrees
            textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(-1 * M_PI/2))
            textAtTop.center = CGPoint(x: imageFrame.origin.x + CGFloat(20), y: imageFrame.origin.y + imageFrame.size.height/2)
        case .BottomRight:
            // If selected template is Right and Bottom then we would change center of Top TextField to Right Edge and transform
            // it by +90 degrees
            textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            textAtTop.center = CGPoint(x: imageFrame.size.width - 30, y: imageFrame.origin.y + imageFrame.size.height/2)
        case .LeftRight:
            // If selected template is Left and Right then we would change center of Top TextField to Left Edge and transform
            // it by -90 degrees and change center of Bottom TextField to Right Edge and transform it by +90 degrees
            textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(-1 * M_PI/2))
            textAtTop.center = CGPoint(x: imageFrame.origin.x + CGFloat(20), y: imageFrame.origin.y + imageFrame.size.height/2)
            textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            textAtBottom.center = CGPoint(x: imageFrame.size.width - 30, y: imageFrame.origin.y + imageFrame.size.height/2)
        case .TopLeft:
            // If selected template is Top and Left then we would change center of Bottom TextField to Left Edge and transform
            // it by -90 degrees
            textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(-1 * M_PI/2))
            textAtBottom.center = CGPoint(x: imageFrame.origin.x + CGFloat(20), y: imageFrame.origin.y + imageFrame.size.height/2)
        case .TopRight:
            // If selected template is Top and Right then we would change center of Bottom TextField to Right Edge and transform
            // it by +90 degrees
            textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            textAtBottom.center = CGPoint(x: imageFrame.size.width, y: imageFrame.origin.y + imageFrame.size.height/2)
        default:
            // No change in Center and Transformation required when Template choosen is Top and Bottom
            print("Nothing needs to be changed for Top Bottom Template")
        }
        
    }
    
    /**
     Resetting Layout after taking screenshot.
     */
    func resetLayout() {
        textAtTop.transform = CGAffineTransformMakeRotation(CGFloat(0))
        textAtBottom.transform = CGAffineTransformMakeRotation(CGFloat(0))
        let imageCenter = selectedImage.center
        let imageSize = selectedImage.frame.size
        textAtTop.center = CGPoint(x: imageCenter.x, y: imageCenter.y - imageSize.height/2 + CGFloat(23))
        textAtBottom.center = CGPoint(x: imageCenter.x, y: imageCenter.y + imageSize.height/2 - CGFloat(23))
    }
    
    /**
     Prepare TextField when EditorMeme View Controller is loaded.
     */
    func setUp(textField:UITextField, withText text:String, textAttributes attributes: [String: AnyObject]) {
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .Center
        textField.backgroundColor = UIColor.clearColor()
    }
    
    /**
     Present Image Picker with SourceType passed as parameter.
     */
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        print("Defaut source type is :\(controller.sourceType.rawValue)")
        presentViewController(controller, animated: true, completion: nil)
    }
}