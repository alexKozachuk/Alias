//
//  CoreDataService.swift
//  Alias
//
//  Created by Sasha on 24/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreData
import Foundation

class CoreDataService {
    
    var teamFetchedResultsController: NSFetchedResultsController<Team> = {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
}
