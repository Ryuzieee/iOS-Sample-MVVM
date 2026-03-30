//
//  GetPokemonListUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン一覧を offset/limit で取得するユースケース。
final class GetPokemonListUseCase {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func callAsFunction(offset: Int, limit: Int) async throws -> [PokemonSummaryModel] {
        try await repository.getPokemonList(offset: offset, limit: limit)
    }
}
