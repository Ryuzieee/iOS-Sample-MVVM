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

/// キャッシュ読み書きの操作をまとめた型。handleWithCache の引数を整理する。
struct CacheStrategy<E> {
    let load: () async throws -> E?
    let cachedAt: ((E) -> Date?)?
    let save: ((E) async throws -> Void)?

    init(
        load: @escaping () async throws -> E?,
        cachedAt: ((E) -> Date?)? = nil,
        save: ((E) async throws -> Void)? = nil
    ) {
        self.load = load
        self.cachedAt = cachedAt
        self.save = save
    }
}

/// キャッシュ付き Repository メソッドの共通ハンドラ。例外を AppError に変換する。
func handleWithCache<D, E, R>(
    forceRefresh: Bool = false,
    cache: CacheStrategy<E>,
    fetch: () async throws -> R,
    toEntity: (R) -> E,
    toModel: (E) -> D
) async throws -> D {
    try await appRun {
        if !forceRefresh {
            if let entity = try await cache.load(),
               !CacheConfig.isExpired(cachedAt: cache.cachedAt?(entity))
            {
                return toModel(entity)
            }
        }
        let raw = try await fetch()
        let entity = toEntity(raw)
        try await cache.save?(entity)
        return toModel(entity)
    }
}

/// API のみの Repository メソッド用ハンドラ。キャッシュなし。
func handleRemote<D, R>(
    fetch: () async throws -> R,
    toModel: (R) -> D
) async throws -> D {
    try await appRun {
        try await toModel(fetch())
    }
}

/// ローカル DB のみの Repository メソッド用ハンドラ。
func handleLocal<D, E>(
    query: () async throws -> E,
    toModel: (E) -> D
) async throws -> D {
    do {
        return try await toModel(query())
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

extension String {
    /// URL 末尾のパスコンポーネントを Int として抽出する。
    /// 例: "https://pokeapi.co/api/v2/pokemon/25/" → 25
    func extractTrailingId(fallback: Int = 0) -> Int {
        guard let last = trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .split(separator: "/")
            .last,
            let value = Int(last)
        else {
            return fallback
        }
        return value
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
