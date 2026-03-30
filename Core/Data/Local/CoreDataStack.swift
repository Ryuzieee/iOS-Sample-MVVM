//
//  CoreDataStack.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation
import CoreData

/// CoreData のスタックを管理するクラス。
final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "iOS_Sample_MVVM")
        container.loadPersistentStores { _, error in
            if let error = error {
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
