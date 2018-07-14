//
//  AppDelegate.swift
//  Todoey
//
//  Created by user140860 on 7/10/18.
//  Copyright © 2018 Vergel de Guzman. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        }
        catch {
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }
}

