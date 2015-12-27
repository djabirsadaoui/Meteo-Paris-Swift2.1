//
//  DJMMainTemperature+CoreDataProperties.swift
//  Meteo
//
//  Created by djabir sadaoui on 24/11/2015.
//  Copyright © 2015 djabir. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DJMMainTemperature {

    @NSManaged var grnd_level: NSNumber?
    @NSManaged var humidity: NSNumber?
    @NSManaged var pressure: NSNumber?
    @NSManaged var sea_level: NSNumber?
    @NSManaged var temp: NSNumber?
    @NSManaged var temp_kf: NSNumber?
    @NSManaged var temp_max: NSNumber?
    @NSManaged var temp_min: NSNumber?

}
