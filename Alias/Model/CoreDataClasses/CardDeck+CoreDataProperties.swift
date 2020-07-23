//
//  CardDeck+CoreDataProperties.swift
//  Alias
//
//  Created by Sasha on 23/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//
//

import UIKit
import CoreData


extension CardDeck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardDeck> {
        return NSFetchRequest<CardDeck>(entityName: "CardDeck")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var photo: UIImage?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CardDeck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
