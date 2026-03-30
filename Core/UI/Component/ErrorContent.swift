//
//  ErrorContent.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// エラー表示とリトライボタンを備えた共通コンポーネント。
struct ErrorContent: View {
    let message: String
    let onRetry: () -> Void
    var errorType: ErrorType = .general

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(displayMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if errorType == .network {
                Text(Strings.Error.networkSubMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Button(Strings.Common.retry, action: onRetry)
                .buttonStyle(.borderedProminent)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var displayMessage: String {
        if errorType == .network {
            return Strings.Error.networkMessage
        }
        return message
    }
}
