//
//  AppLogger.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation
import OSLog

/// アプリ全体で使用するロガー。OSLog ベースでカテゴリ別にログを出力する。
/// Timber (Android) に相当する統一ログ基盤。
enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "iOS-Sample-MVVM"

    static let api = Logger(subsystem: subsystem, category: "API")
    static let data = Logger(subsystem: subsystem, category: "Data")
    static let ui = Logger(subsystem: subsystem, category: "UI")

    /// デバッグビルド時のみ出力する汎用ログ。
    static func debug(_ message: String, category: Logger = data) {
        #if DEBUG
            category.debug("\(message)")
        #endif
    }

    /// エラーログ。
    static func error(_ message: String, category: Logger = data) {
        category.error("\(message)")
    }

    /// API リクエスト/レスポンスのログ。デバッグビルド時のみ出力。
    static func logRequest(url: String) {
        #if DEBUG
            api.debug("→ \(url)")
        #endif
    }

    static func logResponse(url: String, statusCode: Int) {
        #if DEBUG
            api.debug("← \(statusCode) \(url)")
        #endif
    }
}
