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

/// モーダル画面に「閉じる」ToolbarItem を追加する ViewModifier。
struct DismissToolbar: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(Strings.Common.close) { dismiss() }
            }
        }
    }
}

extension View {
    func dismissToolbar() -> some View {
        modifier(DismissToolbar())
    }
}

#Preview {
    HStack(spacing: 16) {
        AppIconButton(systemName: "magnifyingglass", accessibilityLabel: "Search", action: {})
        AppIconButton(systemName: "heart.fill", accessibilityLabel: "Favorite", action: {}, tint: .red)
    }
}
