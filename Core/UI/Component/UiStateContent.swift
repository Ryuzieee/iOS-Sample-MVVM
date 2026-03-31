//
//  UiStateContent.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/04/01.
//

import SwiftUI

/// UiState に応じて Idle / Loading / Error / Success を切り替える共通コンポーネント。
/// 一度 Success になった後は Loading/Error でも前回コンテンツを維持し、エラーはダイアログ表示する。
struct UiStateContent<T: Equatable, SuccessView: View, IdleView: View>: View {
    let state: UiState<T>
    var onRetry: () -> Void = {}
    @ViewBuilder let successContent: (T) -> SuccessView
    @ViewBuilder let idleContent: () -> IdleView

    @State private var cachedData: T?
    @State private var showErrorDialog = false

    var body: some View {
        mainContent
            .errorDialog(
                error: overlayError,
                isPresented: $showErrorDialog,
                onRetry: onRetry
            )
            .onChange(of: state) {
                if case let .success(data) = state {
                    cachedData = data
                } else if case .idle = state {
                    cachedData = nil
                }
                showErrorDialog = false
                if case .error = state, cachedData != nil {
                    showErrorDialog = true
                }
            }
    }

    @ViewBuilder
    private var mainContent: some View {
        if case let .success(data) = state {
            successContent(data)
        } else if case .loading = state, let cached = cachedData {
            successContent(cached)
        } else if case .error = state, let cached = cachedData {
            successContent(cached)
        } else if case .loading = state {
            LoadingIndicator()
        } else if case let .error(appError) = state {
            ErrorContent(error: appError, onRetry: onRetry)
        } else {
            idleContent()
        }
    }

    private var overlayError: AppError? {
        if case let .error(appError) = state, cachedData != nil {
            return appError
        }
        return nil
    }
}

extension UiStateContent where IdleView == EmptyView {
    init(
        state: UiState<T>,
        onRetry: @escaping () -> Void = {},
        @ViewBuilder successContent: @escaping (T) -> SuccessView
    ) {
        self.state = state
        self.onRetry = onRetry
        self.successContent = successContent
        idleContent = { EmptyView() }
    }
}
