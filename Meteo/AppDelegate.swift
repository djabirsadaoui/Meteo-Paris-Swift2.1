//
//  AppDelegate.swift
//  Meteo
//
//  Created by djabir sadaoui on 21/11/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var managedObjectStore: RKManagedObjectStore?
    var window: UIWindow?
    var managedObjectModel: NSManagedObjectModel?
    var objectManager: RKObjectManager?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // apparance de la bar
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.brownColor()]
        UINavigationBar.appearance().tintColor = UIColor.brownColor()
        
        
        let URL = NSURL(string: "http://api.openweathermap.org")
        
        objectManager = RKObjectManager(baseURL: URL)
        
        // retrive main object model from main bundel
        managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        // create store
        managedObjectStore = RKManagedObjectStore(managedObjectModel: managedObjectModel)
        // set store in objct manager
        objectManager!.managedObjectStore = managedObjectStore
               
        // Complete Core Data stack initialization
        managedObjectStore!.createPersistentStoreCoordinator()
        let storBath = RKApplicationDataDirectory().stringByAppendingString("/Meteo.sqlite")
        
        // indicate file used for store
        do {
            try managedObjectStore!.addSQLitePersistentStoreAtPath(storBath, fromSeedDatabaseAtPath: nil, withConfiguration: nil, options: nil)
        }
        catch let error as NSError {
            error.description 
        }
        // Create the managed object contexts
        managedObjectStore!.createManagedObjectContexts()
        // Configure a managed object cache to ensure we do not create duplicate objects
        managedObjectStore!.managedObjectCache = RKInMemoryManagedObjectCache(managedObjectContext: managedObjectStore!.persistentStoreManagedObjectContext)
        
        
        /***************** set mapping between json and obectEntity *******************/
        //  cordinate mapping
        let cordinateMapping = RKEntityMapping(forEntityForName: "DJMCordinate", inManagedObjectStore: managedObjectStore)
        cordinateMapping.addAttributeMappingsFromArray(["lon","lat"])
        /****************************************************************/
        
        // city mapping
        let cityMapping = RKEntityMapping(forEntityForName: "DJMCity", inManagedObjectStore: managedObjectStore)
        cityMapping.addAttributeMappingsFromArray(["id","name","country","population"])
        cityMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "coord", toKeyPath: "coord", withMapping: cordinateMapping))
        /****************************************************************/
        
        // weather mapping
        let weatherMapping = RKEntityMapping(forEntityForName: "DJMWeather", inManagedObjectStore: managedObjectStore)
        weatherMapping.addAttributeMappingsFromDictionary(["main":"main","description":"wDescription","icon":"icon"])
        /****************************************************************/
        
        // main tempirature mapping
        let mainTemperatureMapping = RKEntityMapping(forEntityForName: "DJMMainTemperature", inManagedObjectStore: managedObjectStore)
        mainTemperatureMapping.addAttributeMappingsFromArray(["temp","temp_min","temp_max","pressure","sea_level","grnd_level","humidity","temp_kf"])
        /****************************************************************/
        
        // wind mapping
        let windMapping = RKEntityMapping(forEntityForName: "DJMwind", inManagedObjectStore: managedObjectStore)
        windMapping.addAttributeMappingsFromArray(["speed","deg"])
        /****************************************************************/
        
        
        // weeather with date mapping
        let weatherWithDateMapping = RKEntityMapping(forEntityForName: "DJMWeatherWithDate", inManagedObjectStore: managedObjectStore)
        weatherWithDateMapping.addAttributeMappingsFromArray(["dt","dt_txt"])
        weatherWithDateMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "main", toKeyPath: "main", withMapping: mainTemperatureMapping))
        weatherWithDateMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "weather", toKeyPath: "weathers", withMapping: weatherMapping))
        weatherWithDateMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "wind", toKeyPath: "wind", withMapping: windMapping))
        /****************************************************************/
        
        // global weather mapping
        let gloabalWeatherMapping = RKEntityMapping(forEntityForName: "DJMGlobalWeather", inManagedObjectStore: managedObjectStore)
        gloabalWeatherMapping.addAttributeMappingsFromArray(["cod","message","cnt"])
        gloabalWeatherMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "city", toKeyPath: "city", withMapping: cityMapping))
        gloabalWeatherMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "list", toKeyPath: "list", withMapping: weatherWithDateMapping))
        /****************************************************************/
        
        // discriptor user for mapping json to object
         let responseDescriptor = RKResponseDescriptor(mapping: gloabalWeatherMapping, method: RKRequestMethod.GET, pathPattern:nil, keyPath: nil, statusCodes: NSIndexSet ( index : 200 ))
        
        // add url sifux to base url of object manager
        objectManager?.addResponseDescriptor(responseDescriptor)
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        

        
        
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
        // Saves changes in the application's managed object context before the application terminates.
       
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.sadaoui.Meteo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

   
}

