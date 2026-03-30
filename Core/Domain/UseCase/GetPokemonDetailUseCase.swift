//
//  GetPokemonDetailUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン詳細を取得するユースケース。
final class GetPokemonDetailUseCase {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String, forceRefresh: Bool = false) async throws -> PokemonDetailModel {
        try await repository.getPokemonDetail(name: name, forceRefresh: forceRefresh)
    }
}
