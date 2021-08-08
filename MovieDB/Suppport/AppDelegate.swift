//
//  AppDelegate.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/22/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Đây là link Realm Database",  Realm.Configuration.defaultConfiguration.fileURL!)
        Thread.sleep(forTimeInterval: 1.5)
            
        let screenBound = UIScreen.main.bounds
        window = UIWindow(frame: screenBound)
        window?.makeKeyAndVisible()

        gotoHomeScreen()
        
        return true
    }
    
    private func gotoWalkThought() {
        let walkThoughtScreen = WalkThroughViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: walkThoughtScreen)
        window?.rootViewController = navigationController
    }
    
    private func gotoHomeScreen() {
        let homeScreen = HomeController.instantiate()
        let navigationController = UINavigationController(rootViewController: homeScreen)
        window?.rootViewController = navigationController
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print(Realm.Configuration.defaultConfiguration)
    }
}

