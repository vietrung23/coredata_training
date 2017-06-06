//
//  DataManager.swift
//  CoreDataTraining
//
//  Created by Nguyen Van TRUNG on 6/6/17.
//  Copyright © 2017 altplus. All rights reserved.
//

import Foundation
import CoreData

final class DataManager {
    
    //MARK: - Properties
    
    fileprivate var modelName: String
    
    //MARK: - Initilization
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    //MARK: - Core Data Stack
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentDirectoryURL.appendingPathComponent(storeName)
        
        do {
            let options = [NSInferMappingModelAutomaticallyOption: true,
                           NSMigratePersistentStoresAutomaticallyOption: true]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("There is no model with this URL")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load Data Model")
        }
        
        return mom
    }()
}
