//
//  FavoriteMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import CoreData
import Foundation

/// CoreData の FavoriteEntity (NSManagedObject) ↔ FavoriteModel の変換。
enum FavoriteMapper {
    static func toModel(from entity: NSManagedObject) -> FavoriteModel {
        FavoriteModel(
            id: Int(entity.value(forKey: "id") as? Int64 ?? 0),
            name: entity.value(forKey: "name") as? String ?? "",
            imageUrl: entity.value(forKey: "imageUrl") as? String ?? ""
        )
    }

    static func applyToEntity(_ entity: NSManagedObject, from detail: PokemonDetailModel) {
        entity.setValue(Int64(detail.id), forKey: "id")
        entity.setValue(detail.name, forKey: "name")
        entity.setValue(detail.imageUrl, forKey: "imageUrl")
        entity.setValue(Date(), forKey: "savedAt")
    }
}
