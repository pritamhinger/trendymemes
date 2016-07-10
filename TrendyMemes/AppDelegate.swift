//
//  AppDelegate.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 07/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var memeEditorSetting: MemeEditorSetting = MemeEditorSetting()
    var memes = [Meme]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        initializeMemeEditorSettings()
//        memes.append(Meme(titleAtTop: "",titleAtBottom: "",imageToBeMemed: UIImage(),memedImage: UIImage()))
//        memes.append(Meme(titleAtTop: "",titleAtBottom: "",imageToBeMemed: UIImage(),memedImage: UIImage()))
//        memes.append(Meme(titleAtTop: "",titleAtBottom: "",imageToBeMemed: UIImage(),memedImage: UIImage()))
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Private Methods
    func initializeMemeEditorSettings(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var fontName = StringConstants.Default.FontName
        var fontSize = StringConstants.Default.FontSize
        
        if let name = userDefaults.valueForKey(StringConstants.DictionaryKeys.FontName){
            fontName = name as! String
        }
        else{
            fontName = StringConstants.Default.FontName
        }
        
        if let size = userDefaults.valueForKey(StringConstants.DictionaryKeys.FontSize){
            fontSize = size as! Int
        }
        else{
            fontSize = StringConstants.Default.FontSize
        }
        
        userDefaults.setObject(fontName, forKey: StringConstants.DictionaryKeys.FontName)
        userDefaults.setInteger(fontSize, forKey: StringConstants.DictionaryKeys.FontSize)
        
        memeEditorSetting.fontSetting = FontSetting(name: fontName, size: fontSize, strokeColor: UIColor.blackColor(), foregroundColor: UIColor.whiteColor())
        
        if let templateSetting = userDefaults.valueForKey(StringConstants.DictionaryKeys.TemplateType){
            memeEditorSetting.templateSetting = TemplateSetting(rawValue: templateSetting as! Int)!
        }
        else{
            memeEditorSetting.templateSetting = TemplateSetting.TopBottom
            userDefaults.setInteger(memeEditorSetting.templateSetting.rawValue, forKey: StringConstants.DictionaryKeys.TemplateType)
        }
    }
}

