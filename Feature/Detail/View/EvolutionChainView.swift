//
//  EvolutionChainView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// 進化チェーンを横スクロールで表示するコンポーネント。
struct EvolutionChainView: View {
    let stages: [EvolutionStageModel]
    let currentName: String
    let onStageTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Array(stages.enumerated()), id: \.element.id) { index, stage in
                    if index > 0 {
                        VStack(spacing: 2) {
                            Image(systemName: "arrow.right")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            if let level = stage.minLevel {
                                Text("\(Strings.Detail.evolutionLevelPrefix)\(level)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    EvolutionStageItem(
                        stage: stage,
                        isCurrent: stage.name == currentName,
                        onTap: {
                            if stage.name != currentName {
                                onStageTap(stage.name)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct EvolutionStageItem: View {
    let stage: EvolutionStageModel
    let isCurrent: Bool
    let onTap: () -> Void

    private var displayName: String {
        stage.japaneseName.isEmpty ? stage.name.capitalized : stage.japaneseName
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                PokemonImage(
                    imageUrl: stage.imageUrl,
                    size: 80
                )
                .opacity(isCurrent ? 1.0 : 0.6)

                Text(displayName)
                    .font(isCurrent ? .caption : .caption2)
                    .fontWeight(isCurrent ? .bold : .regular)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 8)
        }
        .buttonStyle(.plain)
        .disabled(isCurrent)
    }
}
