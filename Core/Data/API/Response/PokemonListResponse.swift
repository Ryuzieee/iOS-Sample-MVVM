//
//  PokemonListResponse.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン一覧APIレスポンスのDTO。
struct PokemonListResponse: Decodable {
    let results: [Item]

    struct Item: Decodable {
        let name: String
        let url: String
    }
}
