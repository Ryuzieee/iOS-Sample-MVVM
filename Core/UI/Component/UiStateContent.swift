//
//  UiStateContent.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import SwiftUI

/// UiState に応じて Idle / Loading / Error / Success を切り替える共通コンポーネント。
///
/// 一度 Success になった後は Loading/Error でも前回コンテンツを維持し、エラーはダイアログ表示する。
struct UiStateContent<T: Equatable, SuccessContent: View, IdleContent: View>: View {
    let state: UiState<T>
    let onRetry: () -> Void
    @ViewBuilder let content: (T) -> SuccessContent
    @ViewBuilder let idleContent: () -> IdleContent

    @State private var cachedData: T?
    @State private var errorDismissed = false
    @State private var showSessionExpired = false
    @State private var showForceUpdate = false
    @State private var forceUpdateUrl = ""

    init(
        state: UiState<T>,
        onRetry: @escaping () -> Void = {},
        @ViewBuilder content: @escaping (T) -> SuccessContent,
        @ViewBuilder idleContent: @escaping () -> IdleContent = { EmptyView() }
    ) {
        self.state = state
        self.onRetry = onRetry
        self.content = content
        self.idleContent = idleContent
    }

    var body: some View {
        mainContent
            .onChange(of: state) { _ in errorDismissed = false }
            .onChange(of: state) { newState in
                if case let .success(data) = newState {
                    cachedData = data
                } else if case .idle = newState {
                    cachedData = nil
                }
            }
            .sessionExpiredDialog(isPresented: $showSessionExpired)
            .forceUpdateDialog(storeUrl: forceUpdateUrl, isPresented: $showForceUpdate)
    }

    @ViewBuilder
    private var mainContent: some View {
        switch state {
        case let .success(data):
            content(data)

        case .loading:
            if let cached = cachedData {
                content(cached)
            } else {
                LoadingIndicator()
            }

        case let .error(message, type):
            if let cached = cachedData {
                content(cached)
                    .overlay {
                        if !errorDismissed {
                            Color.clear.onAppear {
                                showErrorOverlay(message: message, type: type)
                            }
                        }
                    }
            } else {
                errorFullScreen(message: message, type: type)
            }

        case .idle:
            idleContent()
        }
    }

    @ViewBuilder
    private func errorFullScreen(message: String, type: ErrorType) -> some View {
        switch type {
        case .general, .network:
            ErrorContent(message: message, onRetry: onRetry, errorType: type)
        case .sessionExpired:
            Color.clear.onAppear { showSessionExpired = true }
        case let .forceUpdate(storeUrl):
            Color.clear.onAppear {
                forceUpdateUrl = storeUrl
                showForceUpdate = true
            }
        }
    }

    private func showErrorOverlay(message _: String, type: ErrorType) {
        switch type {
        case .sessionExpired:
            showSessionExpired = true
        case let .forceUpdate(storeUrl):
            forceUpdateUrl = storeUrl
            showForceUpdate = true
        default:
            break
        }
    }
}
