//
//  Team+CoreDataProperties.swift
//  Alias
//
//  Created by Sasha on 23/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//
//

import UIKit
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var color: UIColor?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var photo: UIImage?
    @NSManaged public var points: Int16

}
