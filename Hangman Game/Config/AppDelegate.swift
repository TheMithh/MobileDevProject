//
//  AppDelegate.swift
//  Hangman Game

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Simplified for prototype - just do basic setup
        setUpNavBarFormatting()
        
        return true
    }
    
    func scheduleNotification() {
        // Disabled for prototype
    }
    
    func registerCategories() {
        // Disabled for prototype
    }
    
    func setUpNavBarFormatting() {
        UINavigationBar.appearance().barTintColor = UIColor(named: K.Colours.bgColour)
        UINavigationBar.appearance().tintColor = UIColor(named: K.Colours.buttonColour)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: K.Fonts.retroGaming, size: 22.0)!]
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: K.Fonts.retroGaming, size: 15.0)!], for: .normal)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
