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
    
    /// This is our collection of **Modal Objects** which is being used as datasource by Collection View and Table View
    var memes = [Meme]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Setting bar tint color and tint color for all navigatoin bars used in app.
        UINavigationBar.appearance().barTintColor = UIColor(red: 255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // Setting Navigation Bar Title attribute to Custom Font
        if let barFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22.0){
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:barFont];
        }
        
        // Setting tint color of UITabbar to override the default blue tint color to make tab bar color in accorance to Navigation Bar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        UITabBar.appearance().tintColor = UIColor(red: 255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        // Initializing Meme Editor Settings
        initializeMemeEditorSettings()
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

