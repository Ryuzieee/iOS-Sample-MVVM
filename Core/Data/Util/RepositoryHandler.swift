//
//  RepositoryHandler.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

private let unauthorizedCode = 401
private let forceUpdateCode = 426
private let defaultStoreUrl = "https://apps.apple.com"

/// キャッシュ付き Repository メソッドの共通ハンドラ。例外を AppError に変換する。
func handleWithCache<D, E, R>(
    forceRefresh: Bool = false,
    load: () async throws -> E?,
    fetch: () async throws -> R,
    toEntity: (R) -> E,
    toModel: (E) -> D,
    cachedAt: ((E) -> Date?)? = nil,
    save: ((E) async throws -> Void)? = nil
) async throws -> D {
    try await appRun {
        if !forceRefresh {
            if let entity = try await load(),
               !CacheConfig.isExpired(cachedAt: cachedAt?(entity))
            {
                return toModel(entity)
            }
        }
        let raw = try await fetch()
        let entity = toEntity(raw)
        try await save?(entity)
        return toModel(entity)
    }
}

/// API のみの Repository メソッド用ハンドラ。キャッシュなし。
func handleRemote<D, R>(
    fetch: () async throws -> R,
    toModel: (R) -> D
) async throws -> D {
    try await appRun {
        try toModel(await fetch())
    }
}

/// ローカル DB のみの Repository メソッド用ハンドラ。
func handleLocal<D, E>(
    query: () async throws -> E,
    toModel: (E) -> D
) async throws -> D {
    do {
        return try toModel(await query())
    } catch {
        throw AppError.unknown(error.localizedDescription)
    }
}

private func appRun<D>(_ block: () async throws -> D) async throws -> D {
    do {
        return try await block()
    } catch {
        throw error.toAppError()
    }
}

extension Error {
    func toAppError() -> AppError {
        if let appError = self as? AppError {
            return appError
        }
        if let urlError = self as? URLError {
            return .network(urlError.localizedDescription)
        }
        if let httpError = self as? HTTPResponseError {
            switch httpError.statusCode {
            case unauthorizedCode:
                return .sessionExpired
            case forceUpdateCode:
                return .forceUpdate(storeUrl: httpError.storeUrl ?? defaultStoreUrl)
            default:
                return .server(code: httpError.statusCode)
            }
        }
        return .unknown(localizedDescription)
    }
}

/// HTTP ステータスコードエラー。PokeAPIClient から throw する。
struct HTTPResponseError: Error {
    let statusCode: Int
    let storeUrl: String?

    init(statusCode: Int, storeUrl: String? = nil) {
        self.statusCode = statusCode
        self.storeUrl = storeUrl
    }
}
