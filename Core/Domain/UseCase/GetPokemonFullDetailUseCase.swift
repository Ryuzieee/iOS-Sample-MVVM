//
//  GetPokemonFullDetailUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// 詳細画面に必要な全データを一括取得するユースケース。基本情報取得後、補足情報を並列取得する。
final class GetPokemonFullDetailUseCase {
    private let getPokemonDetailUseCase: GetPokemonDetailUseCase
    private let getPokemonSpeciesUseCase: GetPokemonSpeciesUseCase
    private let getEvolutionChainUseCase: GetEvolutionChainUseCase
    private let getAbilityJapaneseNameUseCase: GetAbilityJapaneseNameUseCase

    init(
        getPokemonDetailUseCase: GetPokemonDetailUseCase,
        getPokemonSpeciesUseCase: GetPokemonSpeciesUseCase,
        getEvolutionChainUseCase: GetEvolutionChainUseCase,
        getAbilityJapaneseNameUseCase: GetAbilityJapaneseNameUseCase
    ) {
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
        self.getPokemonSpeciesUseCase = getPokemonSpeciesUseCase
        self.getEvolutionChainUseCase = getEvolutionChainUseCase
        self.getAbilityJapaneseNameUseCase = getAbilityJapaneseNameUseCase
    }

    func callAsFunction(name: String, forceRefresh: Bool = false) async throws -> PokemonFullDetailModel {
        let detail = try await getPokemonDetailUseCase(name: name, forceRefresh: forceRefresh)

        async let speciesTask = try? getPokemonSpeciesUseCase(name: name)
        async let chainTask = try? getEvolutionChainUseCase(name: name)
        async let abilitiesTask = resolveAbilityNames(detail: detail)

        let species = await speciesTask
        let chain = await chainTask ?? []
        let resolvedDetail = await abilitiesTask

        return PokemonFullDetailModel(
            detail: resolvedDetail,
            species: species,
            evolutionChain: chain
        )
    }

    private func resolveAbilityNames(detail: PokemonDetailModel) async -> PokemonDetailModel {
        await withTaskGroup(of: (Int, String).self) { group in
            for (index, ability) in detail.abilities.enumerated() {
                group.addTask {
                    let jaName = try? await self.getAbilityJapaneseNameUseCase(name: ability.name)
                    return (index, jaName ?? ability.name)
                }
            }

            var jaNames = Array(repeating: "", count: detail.abilities.count)
            for await (index, jaName) in group {
                jaNames[index] = jaName
            }

            var updated = detail
            updated.abilities = zip(detail.abilities, jaNames).map { ability, jaName in
                PokemonDetailModel.Ability(
                    name: ability.name,
                    japaneseName: jaName,
                    isHidden: ability.isHidden
                )
            }
            return updated
        }
    }
}
