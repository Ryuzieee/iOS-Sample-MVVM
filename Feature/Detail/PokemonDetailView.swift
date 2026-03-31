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
           !species.japaneseName.isEmpty
        {
            return species.japaneseName
        }
        return viewModel.pokemonName.capitalized
    }

    var body: some View {
        Group {
            switch viewModel.content {
            case .loading:
                LoadingIndicator()
            case let .error(appError):
                ErrorContent(error: appError, onRetry: viewModel.retry)
            case let .success(fullDetail):
                detailContent(fullDetail)
            case .idle:
                EmptyView()
            }
        }
        .navigationTitle(displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AppIconButton(
                    systemName: "info.circle",
                    accessibilityLabel: Strings.Detail.infoButtonDescription,
                    action: { showInfo = true }
                )
                AppIconButton(
                    systemName: viewModel.isFavorite ? "heart.fill" : "heart",
                    accessibilityLabel: viewModel.isFavorite ? Strings.Detail.removeFavoriteDescription : Strings.Detail
                        .addFavoriteDescription,
                    action: viewModel.toggleFavorite,
                    tint: viewModel.isFavorite ? .red : .primary
                )
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
        .task {
            viewModel.loadIfNeeded()
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    private func detailContent(_ fullDetail: PokemonFullDetailModel) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                PokemonImage(
                    imageUrl: fullDetail.detail.imageUrl,
                    size: 200
                )

                PokemonIdText(id: fullDetail.detail.id)
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

                TypeBadges(types: fullDetail.detail.types)
                    .padding(.vertical, 8)

                Text(Strings.Detail.heightWeight(
                    heightCm: fullDetail.detail.height * 10,
                    weightKg: Double(fullDetail.detail.weight) / 10.0
                ))
                .font(.subheadline)
                .padding(.bottom, 16)

                if fullDetail.evolutionChain.count > 1 {
                    SectionHeader(title: Strings.Detail.sectionEvolution)
                    EvolutionChainView(
                        stages: fullDetail.evolutionChain,
                        currentName: fullDetail.detail.name,
                        onStageTap: onPokemonTap
                    )
                    .padding(.bottom, 16)
                }

                SectionHeader(title: Strings.Detail.sectionBaseStats)
                BaseStatsSection(stats: fullDetail.detail.stats)
            }
            .padding(.bottom, 32)
        }
    }
}

private struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading, 16)
                .padding(.bottom, 8)
            Spacer()
        }
    }
}

private struct TypeBadges: View {
    let types: [String]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(types, id: \.self) { type in
                Text(Strings.Translation.type(type))
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

private struct BaseStatsSection: View {
    let stats: [PokemonDetailModel.Stat]

    var body: some View {
        ForEach(stats, id: \.name) { stat in
            StatRow(stat: stat)
        }
    }
}

private struct StatRow: View {
    let stat: PokemonDetailModel.Stat

    var body: some View {
        HStack {
            Text(Strings.Translation.stat(stat.name))
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
