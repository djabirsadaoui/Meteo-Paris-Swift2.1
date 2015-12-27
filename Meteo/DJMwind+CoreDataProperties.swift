//
//  DJMwind+CoreDataProperties.swift
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

extension DJMwind {
    //now says 'compiler, don't check those properties as I have Core Data to take care of the implementation - it will be there at runtime'
    @NSManaged var deg: NSNumber?
    @NSManaged var speed: NSNumber?

}
