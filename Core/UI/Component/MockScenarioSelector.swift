//
//  MockScenarioSelector.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import SwiftUI

/// モックシナリオを実行中に切り替えるボトムシート。選択したら即閉じる。
struct MockScenarioSelector: View {
    @ObservedObject var holder: MockScenarioHolder = .shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text(Strings.Mock.sectionHeader)) {
                    ForEach(MockScenario.presets, id: \.scenario.id) { preset in
                        Button {
                            holder.current = preset.scenario
                            dismiss()
                        } label: {
                            HStack {
                                Text(preset.label)
                                    .foregroundColor(.primary)
                                Spacer()
                                if holder.current == preset.scenario {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(Strings.Mock.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Strings.Common.close) { dismiss() }
                }
            }
        }
    }
}
