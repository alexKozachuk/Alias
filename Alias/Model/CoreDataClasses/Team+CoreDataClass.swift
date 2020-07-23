//
//  Team+CoreDataClass.swift
//  Alias
//
//  Created by Sasha on 20/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Team)
public class Team: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.share.entityForName(entityName: "Team"), insertInto: CoreDataManager.share.persistentContainer.viewContext)
    }
    
    public func clear() {
        self.isActive = false
        self.points = 0
    }
    
}

