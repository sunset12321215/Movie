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
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print(Realm.Configuration.defaultConfiguration)
    }
}

