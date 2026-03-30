//
//  PokemonDetailResponse.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン詳細APIレスポンスのDTO。
struct PokemonDetailResponse: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int
    let types: [TypeSlot]
    let abilities: [AbilitySlot]
    let sprites: Sprites
    let stats: [StatSlot]

    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, types, abilities, sprites, stats
        case baseExperience = "base_experience"
    }

    struct TypeSlot: Decodable {
        let type: TypeInfo
    }

    struct TypeInfo: Decodable {
        let name: String
    }

    struct AbilitySlot: Decodable {
        let ability: AbilityInfo
        let isHidden: Bool

        enum CodingKeys: String, CodingKey {
            case ability
            case isHidden = "is_hidden"
        }
    }

    struct AbilityInfo: Decodable {
        let name: String
    }

    struct Sprites: Decodable {
        let other: Other

        struct Other: Decodable {
            let officialArtwork: OfficialArtwork

            enum CodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
            }

            struct OfficialArtwork: Decodable {
                let frontDefault: String

                enum CodingKeys: String, CodingKey {
                    case frontDefault = "front_default"
                }
            }
        }
    }

    struct StatSlot: Decodable {
        let baseStat: Int
        let stat: StatInfo

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
    }

    struct StatInfo: Decodable {
        let name: String
    }
}
