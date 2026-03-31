//
//  PokemonFullDetailModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// 詳細画面に必要な全データをまとめたモデル。
struct PokemonFullDetailModel: Equatable, Sendable {
    let detail: PokemonDetailModel
    let species: PokemonSpeciesModel?
    let evolutionChain: [EvolutionStageModel]
}
