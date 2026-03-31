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

    @State private var showDialog = false

    var body: some View {
        Group {
            switch error {
            case .sessionExpired, .forceUpdate:
                Color.clear.onAppear { showDialog = true }
            default:
                retryContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sessionExpiredDialog(isPresented: sessionExpiredBinding)
        .forceUpdateDialog(
            storeUrl: forceUpdateStoreUrl,
            isPresented: forceUpdateBinding
        )
    }

    private var sessionExpiredBinding: Binding<Bool> {
        Binding(
            get: { showDialog && error == .sessionExpired },
            set: { showDialog = $0 }
        )
    }

    private var forceUpdateBinding: Binding<Bool> {
        Binding(
            get: { showDialog && error.isForceUpdate },
            set: { showDialog = $0 }
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
