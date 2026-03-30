//
//  EmptyContent.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// データが空の場合に表示するコンポーネント。
struct EmptyContent: View {
    let message: String
    var subMessage: String?

    var body: some View {
        VStack(spacing: 4) {
            Spacer()
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
            if let subMessage {
                Text(subMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
