//
//  Card+CoreDataProperties.swift
//  Alias
//
//  Created by Sasha on 21/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var name: String?
    @NSManaged public var cardDeck: CardDeck?

}
