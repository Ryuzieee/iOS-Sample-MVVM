//
//  GetPokemonSpeciesUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン種族情報（図鑑テキスト等）を取得するユースケース。
final class GetPokemonSpeciesUseCase {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String) async throws -> PokemonSpeciesModel {
        try await repository.getPokemonSpecies(name: name)
    }
}
