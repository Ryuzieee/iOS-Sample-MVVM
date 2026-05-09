//
//  CoreDataStack.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import CoreData
import Foundation

/// CoreData のスタックを管理するクラス。
/// テスト時は `CoreDataStack(inMemory: true)` でインメモリストアを使用可能。
final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    private convenience init() {
        self.init(inMemory: false)
    }

    init(inMemory: Bool) {
        container = NSPersistentContainer(name: "iOS_Sample_MVVM")
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData load failed: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
}
