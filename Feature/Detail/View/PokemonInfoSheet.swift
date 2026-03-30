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
                    if let species = species {
                        // 図鑑テキスト
                        Text(species.flavorText)
                            .font(.body)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)

                        Divider().padding(.vertical, 8)

                        InfoRow(label: "分類", value: species.genus)
                        InfoRow(label: "世代", value: species.generation)
                        if let habitat = species.habitat {
                            InfoRow(label: "生息地", value: habitat)
                        }
                        InfoRow(label: "捕獲率", value: "\(species.captureRate)")
                        InfoRow(label: "タマゴグループ", value: species.eggGroups.joined(separator: " / "))

                        let genderText: String = {
                            if species.genderRate == -1 {
                                return "性別なし"
                            }
                            let female = species.genderRate * 125 / 10
                            let male = 1000 - female
                            return "♂ \(String(format: "%.1f", Double(male) / 10))% / ♀ \(String(format: "%.1f", Double(female) / 10))%"
                        }()
                        InfoRow(label: "性別比", value: genderText)

                        Divider().padding(.vertical, 8)
                    }

                    // 特性
                    Text("とくせい")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)

                    ForEach(Array(detail.abilities.enumerated()), id: \.offset) { _, ability in
                        HStack {
                            Text(ability.japaneseName.isEmpty ? ability.name : ability.japaneseName)
                                .font(.body)
                            Spacer()
                            if ability.isHidden {
                                Text("かくれとくせい")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                    }

                    InfoRow(label: "基礎経験値", value: "\(detail.baseExperience)")
                        .padding(.top, 8)
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("くわしい情報")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") { dismiss() }
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
