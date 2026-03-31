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
}
