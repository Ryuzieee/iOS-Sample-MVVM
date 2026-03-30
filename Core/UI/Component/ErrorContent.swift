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

    @State private var showSessionExpired = false
    @State private var showForceUpdate = false

    var body: some View {
        Group {
            switch errorType {
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

            if errorType == .network {
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
        if errorType == .network {
            return Strings.Error.networkMessage
        }
        return message
    }

    private var forceUpdateStoreUrl: String {
        if case .forceUpdate(let storeUrl) = errorType {
            return storeUrl
        }
        return ""
    }
}
