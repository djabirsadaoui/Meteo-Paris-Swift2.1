//
//  DJMCity+CoreDataProperties.swift
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

extension DJMCity {

    @NSManaged var country: String?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var population: NSNumber?
    @NSManaged var coord: DJMCordinate?

}
