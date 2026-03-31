//
//  CacheConfig.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// アプリ全体の設定定数。
enum AppConfig {
    /// 一覧取得時の1ページあたりの件数。
    static let pageSize = 20
    /// 検索入力のデバウンス時間 (ミリ秒)。
    static let searchDebounceMs = 500
    /// 次ページ読み込みを開始する残りアイテム数の閾値。
    static let paginationThreshold = 4
}

/// PokeAPI のスプライト画像 URL を管理する定数。
enum SpriteURL {
    private static let base = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"

    /// 一覧用の小さいスプライト画像 URL。
    static func sprite(id: Int) -> String { "\(base)\(id).png" }
    /// 詳細用の公式アートワーク画像 URL。
    static func artwork(id: Int) -> String { "\(base)other/official-artwork/\(id).png" }
}

/// キャッシュ有効期間の設定。
enum CacheConfig {
    #if DEBUG
        static let durationSeconds: TimeInterval = 60 // デバッグ: 1分
    #else
        static let durationSeconds: TimeInterval = 300 // リリース: 5分
    #endif

    static func isExpired(cachedAt: Date?) -> Bool {
        guard let cachedAt else { return true }
        return Date().timeIntervalSince(cachedAt) >= durationSeconds
    }
}
