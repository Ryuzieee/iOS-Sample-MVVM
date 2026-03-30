//
//  EvolutionChainMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

private let artworkURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"

/// EvolutionChainResponse → [EvolutionStageModel] への変換。
enum EvolutionChainMapper {
    static func toModel(from response: EvolutionChainResponse) -> [EvolutionStageModel] {
        var stages: [EvolutionStageModel] = []
        walk(link: response.chain, stages: &stages)
        return stages
    }

    private static func walk(link: EvolutionChainResponse.ChainLink, stages: inout [EvolutionStageModel]) {
        let id = extractId(from: link.species.url)
        let minLevel = link.evolutionDetails.first?.minLevel

        stages.append(EvolutionStageModel(
            name: link.species.name,
            japaneseName: "",
            id: id,
            imageUrl: "\(artworkURL)\(id).png",
            minLevel: minLevel
        ))

        for next in link.evolvesTo {
            walk(link: next, stages: &stages)
        }
    }

    private static func extractId(from url: String) -> Int {
        guard let last = url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .split(separator: "/")
            .last,
              let id = Int(last) else {
            return 0
        }
        return id
    }
}
