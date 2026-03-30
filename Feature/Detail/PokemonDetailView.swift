//
//  PokemonDetailView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// ポケモン詳細画面。
struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    let onPokemonTap: (String) -> Void
    @State private var showInfo = false

    private var displayName: String {
        if let species = viewModel.content.dataOrNil?.species,
           !species.japaneseName.isEmpty {
            return species.japaneseName
        }
        return viewModel.pokemonName.capitalized
    }

    var body: some View {
        Group {
            switch viewModel.content {
            case .loading:
                LoadingIndicator()
            case .error(let message, let type):
                ErrorContent(message: message, onRetry: viewModel.retry, errorType: type)
            case .success(let fullDetail):
                detailContent(fullDetail)
            case .idle:
                EmptyView()
            }
        }
        .navigationTitle(displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showInfo = true }) {
                    Image(systemName: "info.circle")
                }
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .primary)
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            if let fullDetail = viewModel.content.dataOrNil {
                PokemonInfoSheet(
                    detail: fullDetail.detail,
                    species: fullDetail.species
                )
            }
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    @ViewBuilder
    private func detailContent(_ fullDetail: PokemonFullDetailModel) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                PokemonImage(
                    imageUrl: fullDetail.detail.imageUrl,
                    size: 200
                )

                Text("#\(fullDetail.detail.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)

                Text(displayName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 4)

                if let species = fullDetail.species {
                    Text(species.genus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }

                // タイプ
                HStack(spacing: 8) {
                    ForEach(fullDetail.detail.types, id: \.self) { type in
                        Text(type.capitalized)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .cornerRadius(16)
                    }
                }
                .padding(.vertical, 8)

                // 身長・体重
                Text("身長: \(fullDetail.detail.height * 10)cm　体重: \(String(format: "%.1f", Double(fullDetail.detail.weight) / 10.0))kg")
                    .font(.subheadline)
                    .padding(.bottom, 16)

                // 進化チェーン
                if fullDetail.evolutionChain.count > 1 {
                    sectionHeader("しんか")
                    EvolutionChainView(
                        stages: fullDetail.evolutionChain,
                        currentName: fullDetail.detail.name,
                        onStageTap: onPokemonTap
                    )
                    .padding(.bottom, 16)
                }

                // 基本ステータス
                sectionHeader("きほんステータス")
                ForEach(fullDetail.detail.stats, id: \.name) { stat in
                    StatRow(stat: stat)
                }
            }
            .padding(.bottom, 32)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading, 16)
                .padding(.bottom, 8)
            Spacer()
        }
    }
}

private struct StatRow: View {
    let stat: PokemonDetailModel.Stat

    var body: some View {
        HStack {
            Text(stat.name.capitalized)
                .font(.caption)
                .frame(width: 80, alignment: .leading)
            ProgressView(value: Double(stat.value), total: 255)
            Text("\(stat.value)")
                .font(.caption)
                .frame(width: 36, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
    }
}
