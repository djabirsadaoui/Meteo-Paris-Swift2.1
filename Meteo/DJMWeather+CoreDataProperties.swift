//
//  DJMWeather+CoreDataProperties.swift
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

extension DJMWeather {

    @NSManaged var icon: String?
    @NSManaged var main: String?
    @NSManaged var wDescription: String?

}
