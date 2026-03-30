//
//  EvolutionChainResponse.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// evolution-chain API レスポンスのDTO。
struct EvolutionChainResponse: Decodable {
    let id: Int
    let chain: ChainLink

    struct ChainLink: Decodable {
        let species: Species
        let evolvesTo: [ChainLink]
        let evolutionDetails: [EvolutionDetail]

        enum CodingKeys: String, CodingKey {
            case species
            case evolvesTo = "evolves_to"
            case evolutionDetails = "evolution_details"
        }
    }

    struct Species: Decodable {
        let name: String
        let url: String
    }

    struct EvolutionDetail: Decodable {
        let minLevel: Int?
        let trigger: Trigger?

        enum CodingKeys: String, CodingKey {
            case minLevel = "min_level"
            case trigger
        }
    }

    struct Trigger: Decodable {
        let name: String
    }
}
