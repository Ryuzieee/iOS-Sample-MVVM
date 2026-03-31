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
                updateCache()
                // エラーダイアログは状態遷移ごとにリセットし、キャッシュありエラーなら再表示
                showErrorDialog = overlayError != nil
            }
    }

    @ViewBuilder
    private var mainContent: some View {
        if let displayData {
            successContent(displayData)
        } else if case .loading = state {
            LoadingIndicator()
        } else if case let .error(appError) = state {
            ErrorContent(error: appError, onRetry: onRetry)
        } else {
            idleContent()
        }
    }

    /// Success のデータ、またはキャッシュ済みデータ（Loading/Error 時に維持）
    private var displayData: T? {
        if case let .success(data) = state { return data }
        if cachedData != nil, case .loading = state { return cachedData }
        if cachedData != nil, case .error = state { return cachedData }
        return nil
    }

    private var overlayError: AppError? {
        if case let .error(appError) = state, cachedData != nil {
            return appError
        }
        return nil
    }

    private func updateCache() {
        if case let .success(data) = state {
            cachedData = data
        } else if case .idle = state {
            cachedData = nil
        }
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
