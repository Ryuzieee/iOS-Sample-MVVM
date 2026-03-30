//
//  AbilityResponse.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ability API レスポンスのDTO（日本語名取得用の最小構造）。
struct AbilityResponse: Decodable {
    let names: [Name]

    struct Name: Decodable {
        let name: String
        let language: NamedResource
    }
}
