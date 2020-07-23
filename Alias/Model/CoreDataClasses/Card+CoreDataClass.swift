//
//  Card+CoreDataClass.swift
//  Alias
//
//  Created by Sasha on 20/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataManager.share.entityForName(entityName: "Card"), insertInto: CoreDataManager.share.persistentContainer.viewContext)
    }
    
    @nonobjc public class func fetchRequest(cardDeck: CardDeck) -> NSFetchRequest<Card> {
        let fetchRequest: NSFetchRequest<Card> = self.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "%K == %@", "cardDeck", cardDeck)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
}


