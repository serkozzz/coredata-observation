//
//  AppDelegate.swift
//  NSFetchRequestController
//
//  Created by Sergey Kozlov on 22.11.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        importJSONSeedDataIfNeeded()
        // Override point for customization after application launch.
        return true
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

func importJSONSeedDataIfNeeded() {

  let fetchRequest: NSFetchRequest<BandDB> = BandDB.fetchRequest()
    let count = try? CoreDataStack.shared.managedContext.count(for: fetchRequest)

  guard let bandCount = count, bandCount == 0 else { return }

  importJSONSeedData()
}

func importJSONSeedData() {
    
    let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")!
    let jsonData = try! Data(contentsOf: jsonURL)
    
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [[String: Any]]
        
        for jsonDictionary in jsonArray {
            let name = jsonDictionary["name"] as! String
            let country = jsonDictionary["country"] as! String
            let genre = jsonDictionary["genre"] as! String
            let year = jsonDictionary["creationYear"] as! NSNumber
            
            let band = BandDB(context: CoreDataStack.shared.managedContext)
            band.name = name
            band.country = country
            band.genre = genre
            band.creationYear = year.int32Value
        }
        
        CoreDataStack.shared.saveContext()
    } catch let error as NSError {
        print("Error importing teams: \(error)")
    }
}
