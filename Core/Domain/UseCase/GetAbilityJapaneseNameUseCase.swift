//
//  GetAbilityJapaneseNameUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// 特性の日本語名を取得するユースケース。
final class GetAbilityJapaneseNameUseCase {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String) async throws -> String {
        let names = try await repository.getAbilityLocalizedNames(name: name)
        return names["ja"] ?? names["ja-Hrkt"] ?? name
    }
}
