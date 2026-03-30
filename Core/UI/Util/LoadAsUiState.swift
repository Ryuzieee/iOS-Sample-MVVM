//
//  LoadAsUiState.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

/// async throws クロージャを実行し、結果を UiState に変換する。
func loadAsUiState<T: Equatable>(_ block: () async throws -> T) async -> UiState<T> {
    do {
        let result = try await block()
        return .success(result)
    } catch {
        AppLogger.error(error.localizedDescription, category: AppLogger.ui)
        return .error(message: error.localizedDescription, type: error.toErrorType())
    }
}

extension Error {
    func toErrorType() -> ErrorType {
        guard let appError = self as? AppError else { return .general }
        switch appError {
        case .network:
            return .network
        case .sessionExpired:
            return .sessionExpired
        case .forceUpdate(let storeUrl):
            return .forceUpdate(storeUrl: storeUrl)
        default:
            return .general
        }
    }
}
