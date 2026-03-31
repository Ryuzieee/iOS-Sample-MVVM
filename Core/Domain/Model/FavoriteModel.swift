//
//  FavoriteModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// お気に入り登録されたポケモンを表すドメインモデル。
struct FavoriteModel: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let imageUrl: String
}
