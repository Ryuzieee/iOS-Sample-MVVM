//
//  CacheConfig.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// キャッシュ有効期間の設定。
enum CacheConfig {
    #if DEBUG
        static let durationSeconds: TimeInterval = 60 // デバッグ: 1分
    #else
        static let durationSeconds: TimeInterval = 300 // リリース: 5分
    #endif

    static func isExpired(cachedAt: Date?) -> Bool {
        guard let cachedAt = cachedAt else { return true }
        return Date().timeIntervalSince(cachedAt) >= durationSeconds
    }
}
