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

        return await withTaskGroup(of: (String, String).self) { group in
            for stage in stages {
                group.addTask {
                    let jaName = try? await self.getPokemonSpeciesUseCase(name: stage.name).japaneseName
                    return (stage.name, jaName ?? "")
                }
            }

            var jaNamesByName: [String: String] = [:]
            for await (name, jaName) in group {
                jaNamesByName[name] = jaName
            }

            return stages.map { stage in
                EvolutionStageModel(
                    name: stage.name,
                    japaneseName: jaNamesByName[stage.name] ?? "",
                    id: stage.id,
                    imageUrl: stage.imageUrl,
                    minLevel: stage.minLevel
                )
            }
        }
    }
}
