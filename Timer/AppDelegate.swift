//
//  AppDelegate.swift
//  Timer
//
//  Created by William Qian on 1/4/19.
//  Copyright © 2019 William Qian. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0
    var currHour = -1
    var currMin = -1
    var currSec = -1
    var prevHour = -1
    var prevMin = -1
    var prevSec = -1
    //var date = Date()
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //if prev time is set, find difference.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print("granted: (\(granted)")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
       // self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
        //    self.endBackgroundUpdateTask()
        //})
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      //set the current time
        let date = Date()
        let calendar = Calendar.current
        prevHour = calendar.component(.hour, from: date)
        prevMin = calendar.component(.minute, from: date)
        prevSec = calendar.component(.second, from: date)
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //self.endBackgroundUpdateTask()
        if(prevHour != -1 && prevMin != -1 && prevSec != -1 && run == true){
            let date2 = Date()
            let calendar2 = Calendar.current
            currHour = calendar2.component(.hour, from: date2)
            currMin = calendar2.component(.minute, from: date2)
            currSec = calendar2.component(.second, from: date2)
            print("curr "+String(format:"%02i:%02i:%02i", currHour, currMin, currSec))
            print("prev "+String(format:"%02i:%02i:%02i", prevHour, prevMin, prevSec))
            var diff = 0
            let currTotal = currHour * 60 * 60 + currMin * 60 + currSec
            let prevTotal = prevHour * 60 * 60 + prevMin * 60 + prevSec
            if( currTotal < prevTotal){
                diff += currTotal + (24*60*60 - prevTotal)
            }
            else{
                //print("currtotal: "+"\(currTotal)"+"prev: "+"\(prevTotal)")
                diff = currTotal - prevTotal
            }
            
            time = max(time - Double(diff),0)
                //print ("\(time)" + "double: "+"\(diff)")
        
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

