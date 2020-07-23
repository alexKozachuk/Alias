//
//  CardDeck+CoreDataClass.swift
//  Alias
//
//  Created by Sasha on 20/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CardDeck)
public class CardDeck: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.share.entityForName(entityName: "CardDeck"), insertInto: CoreDataManager.share.persistentContainer.viewContext)
    }
    
    @nonobjc public class func getSelectedCardDeck() -> NSFetchRequest<CardDeck> {
        let fetchRequest: NSFetchRequest<CardDeck> = self.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "isActive == true")
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    
}
