//
//  AppDelegate.swift
//  ContemPlant
//
//  Created by Gero Embser on 14.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //determine which UI should be shown (depending on whether logged in or not)
        
        let currentUser = User.current
        
        //change root view controller
        changeRootViewController(basedOnLoggedInUser: currentUser, animated: false, completion: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

//MARK: - determine ViewController after Application launch
extension AppDelegate {
    func getInitialViewControllerInstance(forLoggedInUser loggedInUser: User?) -> UIViewController {
        if let loggedInUser = loggedInUser, loggedInUser.loggedIn {
            let plantsNC = UIStoryboard.plantsLearning.instantiateInitialViewController()! as! PlantsNavigationController
            plantsNC.user = loggedInUser
            
            return plantsNC
        }
        else {
            return UIStoryboard.login.instantiateInitialViewController()!
        }
    }
    
    func changeRootViewController(basedOnLoggedInUser loggedInUser: User?, animated: Bool, completion: ((_ completed: Bool) -> Void)?) {
        //make sure, window is not nil, otherwise there's nothing to transition
        guard let window = window else {
            fatalError("Should not happen, to be honest...")
        }
        
        let loggedIn = loggedInUser != nil && loggedInUser!.loggedIn
        
        let newRootViewController = getInitialViewControllerInstance(forLoggedInUser: loggedInUser)
        
        //not animated
        guard animated else {
            window.rootViewController = newRootViewController
            window.makeKeyAndVisible()
            return
        }
        
        //animated
        UIView.transition(with: window, duration: 0.3, options: (loggedIn ? .transitionFlipFromLeft : .transitionFlipFromRight), animations: {
            window.rootViewController = newRootViewController
        }) { (completed) in
            completion?(completed)
        }
        
    }
}


//MARK: - simplified AppDelegate access
extension AppDelegate {
    static var current = UIApplication.shared.delegate! as! AppDelegate
}
