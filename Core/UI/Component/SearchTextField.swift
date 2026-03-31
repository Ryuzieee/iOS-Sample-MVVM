//
//  SearchTextField.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// 検索用テキストフィールド。
struct SearchTextField: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.searchFieldCornerRadius))
    }
}

#Preview {
    SearchTextField(text: .constant("pikachu"), placeholder: "Search Pokemon")
        .padding()
}
