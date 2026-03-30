//
//  SearchPokemonUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン名であいまい検索するユースケース。
final class SearchPokemonUseCase {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [String] {
        let names = try await repository.searchPokemonNames(query: query)
        if names.isEmpty {
            throw AppError.notFound(query: query)
        }
        return names
    }
}
