//
//  UiState.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// 画面の UI 状態を表す汎用 enum。
enum UiState<T: Equatable>: Equatable {
    case idle
    case loading
    case success(T)
    case error(AppError)

    static func == (lhs: UiState<T>, rhs: UiState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            true
        case let (.success(a), .success(b)):
            a == b
        case let (.error(e1), .error(e2)):
            e1 == e2
        default:
            false
        }
    }
}

extension UiState {
    /// Success のデータを返す。それ以外は nil。
    var dataOrNil: T? {
        if case let .success(data) = self { return data }
        return nil
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    var errorOrNil: AppError? {
        if case let .error(appError) = self { return appError }
        return nil
    }
}

extension UiState where T == Bool {
    /// 値を持たない成功状態。UiState<Bool> を読み込み状態の追跡に使う場合用。
    static var loaded: UiState {
        .success(true)
    }
}

/// 非同期データ読み込みの共通パターンを提供するプロトコル。
/// load/retry/refresh/Task キャンセルのボイラープレートを統一する。
@MainActor
protocol AsyncLoadable: ObservableObject {
    associatedtype Content: Equatable
    var content: UiState<Content> { get set }
    var loadTask: Task<Void, Never>? { get set }

    func fetchContent(forceRefresh: Bool) async throws -> Content
}

extension AsyncLoadable {
    func load(forceRefresh: Bool = false) {
        loadTask?.cancel()
        loadTask = Task {
            if !forceRefresh {
                content = .loading
            }
            content = await .from {
                try await fetchContent(forceRefresh: forceRefresh)
            }
        }
    }

    func retry() { load() }
    func refresh() { load(forceRefresh: true) }

    func cancelLoad() { loadTask?.cancel() }
}
