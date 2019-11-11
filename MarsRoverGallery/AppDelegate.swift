//
//  AppDelegate.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/4/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	// Store a reference to the coordinator that handles view controller navigation so it doesn't deinitialize
	var coordinator: MainCoordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
		
		let navigationController = UINavigationController()
		let coordinator = MainCoordinator(navigationController: navigationController)
		self.coordinator = coordinator
		coordinator.start()
		
		window?.rootViewController = navigationController
		
		return true
	}

	// MARK: UISceneSession Lifecycle

//	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//		// Called when a new scene session is being created.
//		// Use this method to select a configuration to create the new scene with.
//		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//	}
//
//	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//		// Called when the user discards a scene session.
//		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//	}


}

