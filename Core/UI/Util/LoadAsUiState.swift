//
//  LoadAsUiState.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

extension UiState {
    /// async throws クロージャを実行し、結果を UiState に変換する。
    static func from(_ block: () async throws -> T) async -> UiState<T> {
        do {
            let result = try await block()
            return .success(result)
        } catch {
            AppLogger.error(error.localizedDescription, category: AppLogger.ui)
            return .error(message: error.localizedDescription, type: error.toErrorType())
        }
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
        case let .forceUpdate(storeUrl):
            return .forceUpdate(storeUrl: storeUrl)
        default:
            return .general
        }
    }
}
