//
//  AppError.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// アプリ内で使用するエラー種別。
enum AppError: LocalizedError, Equatable, Sendable {
    case network(String)
    case server(code: Int)
    case notFound(query: String)
    case sessionExpired
    case forceUpdate(storeUrl: String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .network:
            "通信エラーが発生しました。ネットワーク接続を確認してください。"
        case let .server(code):
            "サーバーエラーが発生しました（\(code)）"
        case let .notFound(query):
            "「\(query)」は見つかりませんでした"
        case .sessionExpired:
            "セッションが切れました。再度ログインしてください。"
        case .forceUpdate:
            "アプリの更新が必要です。"
        case .unknown:
            "不明なエラーが発生しました。"
        }
    }
}
