//
//  GetEvolutionChainUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモンの進化チェーンを取得し、各ステージの日本語名を並列解決する。
final class GetEvolutionChainUseCase {
    private let getPokemonSpeciesUseCase: GetPokemonSpeciesUseCase
    private let repository: PokemonRepositoryProtocol

    init(
        getPokemonSpeciesUseCase: GetPokemonSpeciesUseCase,
        repository: PokemonRepositoryProtocol
    ) {
        self.getPokemonSpeciesUseCase = getPokemonSpeciesUseCase
        self.repository = repository
    }

    func callAsFunction(name: String) async throws -> [EvolutionStageModel] {
        let species = try await getPokemonSpeciesUseCase(name: name)
        let stages = try await repository.getEvolutionChain(url: species.evolutionChainUrl)

        return await withTaskGroup(of: (Int, String).self) { group in
            for (index, stage) in stages.enumerated() {
                group.addTask {
                    let jaName = try? await self.getPokemonSpeciesUseCase(name: stage.name).japaneseName
                    return (index, jaName ?? "")
                }
            }

            var jaNames = Array(repeating: "", count: stages.count)
            for await (index, jaName) in group {
                jaNames[index] = jaName
            }

            return zip(stages, jaNames).map { stage, jaName in
                EvolutionStageModel(
                    name: stage.name,
                    japaneseName: jaName,
                    id: stage.id,
                    imageUrl: stage.imageUrl,
                    minLevel: stage.minLevel
                )
            }
        }
    }
}
