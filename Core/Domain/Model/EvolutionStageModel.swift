//
//  EvolutionStageModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// 進化チェーンの1段階を表す。
struct EvolutionStageModel: Identifiable, Equatable, Sendable {
    let name: String
    let japaneseName: String
    let id: Int
    let imageUrl: String
    let minLevel: Int?
}
