//
//  ErrorContent.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// エラー表示とリトライボタンを備えた共通コンポーネント。
struct ErrorContent: View {
    let error: AppError
    let onRetry: () -> Void

    @State private var showSessionExpired = false
    @State private var showForceUpdate = false

    var body: some View {
        Group {
            switch error {
            case .sessionExpired:
                Color.clear.onAppear { showSessionExpired = true }
            case .forceUpdate:
                Color.clear.onAppear { showForceUpdate = true }
            default:
                retryContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sessionExpiredDialog(isPresented: $showSessionExpired)
        .forceUpdateDialog(
            storeUrl: forceUpdateStoreUrl,
            isPresented: $showForceUpdate
        )
    }

    private var retryContent: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(displayMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if case .network = error {
                Text(Strings.Error.networkSubMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Button(Strings.Common.retry, action: onRetry)
                .buttonStyle(.borderedProminent)
            Spacer()
        }
    }

    private var displayMessage: String {
        if case .network = error {
            return Strings.Error.networkMessage
        }
        return error.errorDescription ?? Strings.Common.errorTitle
    }

    private var forceUpdateStoreUrl: String {
        if case let .forceUpdate(storeUrl) = error {
            return storeUrl
        }
        return ""
    }
}

#Preview("General Error") {
    ErrorContent(error: .unknown("Something went wrong"), onRetry: {})
}

#Preview("Network Error") {
    ErrorContent(error: .network("Network error"), onRetry: {})
}
