//
//  FavoriteMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import CoreData
import Foundation

/// CoreData の FavoriteEntity (NSManagedObject) ↔ FavoriteModel の変換。
extension FavoriteModel {
    init(from entity: NSManagedObject) {
        self.init(
            id: Int(entity.value(forKey: "id") as? Int64 ?? 0),
            name: entity.value(forKey: "name") as? String ?? "",
            imageUrl: entity.value(forKey: "imageUrl") as? String ?? ""
        )
    }
}

extension NSManagedObject {
    func applyFavorite(from detail: PokemonDetailModel) {
        setValue(Int64(detail.id), forKey: "id")
        setValue(detail.name, forKey: "name")
        setValue(detail.imageUrl, forKey: "imageUrl")
        setValue(Date(), forKey: "savedAt")
    }
}
