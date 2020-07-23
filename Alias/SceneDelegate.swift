//
//  SceneDelegate.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        checkFirstRun()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        CoreDataManager.share.saveContext()
    }

    
    func checkFirstRun() {
        let defaults = UserDefaultsManager.share
        guard defaults.getBool(key: .firstRun) == false else { return }
        
        
        let backgroundContext = CoreDataManager.share.persistentContainer.newBackgroundContext()
        CoreDataManager.share.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        guard let urlPath = Bundle.main.url(forResource: "PreloadedData", withExtension: "plist") else { return }
        
        guard let dictionary = NSDictionary(contentsOf: urlPath) as? [String: Any] else { return }
        guard let cardDecks = dictionary["cardDecks"] as? [Any] else { return }
        
        for cardDeck in cardDecks {
            guard let cardDeck = cardDeck as? [String: Any] else { return }
            guard let imageName = cardDeck["imageName"] as? String else { return }
            guard let name = cardDeck["name"] as? String else { return }
            guard let array = cardDeck["cards"] as? [String] else { return }
            guard let image = UIImage(named: imageName) else { return }
            
            do {
                let cardDeck1 = CardDeck(context: backgroundContext)
                cardDeck1.name = name
                cardDeck1.photo = image
                
                array.forEach { item in
                    let card = Card(context: backgroundContext)
                    card.name = item
                    card.cardDeck = cardDeck1
                }
                
                try backgroundContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        
        
        
        
        
        
        for team in TeamStoarge.shared.teams {
            let item = Team()
            item.name = team.name
            item.color = team.color
            item.isActive = false
            item.photo = team.image
            item.points = 0
            CoreDataManager.share.saveContext()
        }
        defaults.setInt(item: 60, key: .timeRound)
        defaults.setInt(item: 50, key: .winPoints)
        defaults.setBool(item: true, key: .firstRun)
        defaults.setBool(item: true, key: .penalty)
        
    }

}


