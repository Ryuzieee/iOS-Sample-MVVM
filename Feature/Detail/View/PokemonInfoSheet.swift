//
//  PokemonInfoSheet.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// ポケモン詳細情報のボトムシート。
struct PokemonInfoSheet: View {
    let detail: PokemonDetailModel
    let species: PokemonSpeciesModel?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let species {
                        Text(species.flavorText)
                            .font(.body)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)

                        Divider().padding(.vertical, 8)

                        InfoRow(label: Strings.Detail.labelCategory, value: species.genus)
                        InfoRow(
                            label: Strings.Detail.labelGeneration,
                            value: Strings.Translation.generation(species.generation)
                        )
                        if let habitat = species.habitat {
                            InfoRow(label: Strings.Detail.labelHabitat, value: Strings.Translation.habitat(habitat))
                        }
                        InfoRow(label: Strings.Detail.labelCaptureRate, value: "\(species.captureRate)")
                        InfoRow(
                            label: Strings.Detail.labelEggGroup,
                            value: species.eggGroups.map { Strings.Translation.eggGroup($0) }
                                .joined(separator: Strings.Detail.eggGroupSeparator)
                        )

                        InfoRow(label: Strings.Detail.labelGenderRatio, value: species.genderText)

                        Divider().padding(.vertical, 8)
                    }

                    Text(Strings.Detail.labelAbilities)
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)

                    ForEach(Array(detail.abilities.enumerated()), id: \.offset) { _, ability in
                        HStack {
                            Text(ability.japaneseName.isEmpty ? ability.name : ability.japaneseName)
                                .font(.body)
                            Spacer()
                            if ability.isHidden {
                                Text(Strings.Detail.labelHiddenAbility)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color(.systemGray5))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                    }

                    InfoRow(label: Strings.Detail.labelBaseExperience, value: "\(detail.baseExperience)")
                        .padding(.top, 8)
                }
                .padding(.bottom, 16)
            }
            .navigationTitle(Strings.Detail.bottomSheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Strings.Common.close) { dismiss() }
                }
            }
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .font(.body)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
    }
}
