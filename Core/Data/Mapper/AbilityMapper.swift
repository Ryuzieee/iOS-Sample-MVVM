//
//  AbilityMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// AbilityResponse → [言語コード: 名前] の辞書への変換。
extension AbilityResponse {
    func toLocalizedNames() -> [String: String] {
        Dictionary(
            names.map { ($0.language.name, $0.name) },
            uniquingKeysWith: { first, _ in first }
        )
    }
}
