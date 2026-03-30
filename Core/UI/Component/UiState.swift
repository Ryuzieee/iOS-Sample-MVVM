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
    case error(message: String, type: ErrorType)

    static func == (lhs: UiState<T>, rhs: UiState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.success(let a), .success(let b)):
            return a == b
        case (.error(let m1, let t1), .error(let m2, let t2)):
            return m1 == m2 && t1 == t2
        default:
            return false
        }
    }
}

/// UiState.Error の種別。
enum ErrorType: Equatable {
    case general
    case network
    case sessionExpired
    case forceUpdate(storeUrl: String)
}

extension UiState {
    /// Success のデータを返す。それ以外は nil。
    var dataOrNil: T? {
        if case .success(let data) = self { return data }
        return nil
    }
}
