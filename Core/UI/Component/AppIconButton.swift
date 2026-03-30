//
//  AppIconButton.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import SwiftUI

/// SF Symbols アイコン + Button を1呼び出しにまとめた共通コンポーネント。
struct AppIconButton: View {
    let systemName: String
    let accessibilityLabel: String
    let action: () -> Void
    var tint: Color = .primary

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(tint)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    HStack(spacing: 16) {
        AppIconButton(systemName: "magnifyingglass", accessibilityLabel: "Search", action: {})
        AppIconButton(systemName: "heart.fill", accessibilityLabel: "Favorite", action: {}, tint: .red)
    }
}
