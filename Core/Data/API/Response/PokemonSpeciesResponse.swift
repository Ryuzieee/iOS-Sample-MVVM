//
//  PokemonSpeciesResponse.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// pokemon-species API レスポンスのDTO。
struct PokemonSpeciesResponse: Decodable {
    let names: [Name]
    let flavorTextEntries: [FlavorTextEntry]
    let evolutionChain: EvolutionChainRef
    let genera: [Genus]
    let eggGroups: [NamedResource]
    let genderRate: Int
    let captureRate: Int
    let habitat: NamedResource?
    let generation: NamedResource

    enum CodingKeys: String, CodingKey {
        case names, genera, habitat, generation
        case flavorTextEntries = "flavor_text_entries"
        case evolutionChain = "evolution_chain"
        case eggGroups = "egg_groups"
        case genderRate = "gender_rate"
        case captureRate = "capture_rate"
    }

    struct Name: Decodable {
        let name: String
        let language: NamedResource
    }

    struct FlavorTextEntry: Decodable {
        let flavorText: String
        let language: NamedResource
        let version: NamedResource

        enum CodingKeys: String, CodingKey {
            case language, version
            case flavorText = "flavor_text"
        }
    }

    struct Genus: Decodable {
        let genus: String
        let language: NamedResource
    }

    struct EvolutionChainRef: Decodable {
        let url: String
    }
}

/// 汎用の名前+URL リソース。
struct NamedResource: Decodable {
    let name: String
    let url: String?

    init(name: String, url: String? = nil) {
        self.name = name
        self.url = url
    }
}
