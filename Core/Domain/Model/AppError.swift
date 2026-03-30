//
//  AppError.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// アプリ内で使用するエラー種別。
enum AppError: LocalizedError, Equatable {
    case network(String)
    case server(code: Int)
    case notFound(query: String)
    case sessionExpired
    case forceUpdate(storeUrl: String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .network:
            return "通信エラーが発生しました。ネットワーク接続を確認してください。"
        case .server(let code):
            return "サーバーエラーが発生しました（\(code)）"
        case .notFound(let query):
            return "「\(query)」は見つかりませんでした"
        case .sessionExpired:
            return "セッションが切れました。再度ログインしてください。"
        case .forceUpdate:
            return "アプリの更新が必要です。"
        case .unknown:
            return "不明なエラーが発生しました。"
        }
    }
}
