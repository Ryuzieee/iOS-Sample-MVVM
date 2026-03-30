//
//  MockScenario.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Combine
import Foundation

/// モックレスポンスのシナリオ。MockAPIClient が返すレスポンスを切り替えるために使用する。
enum MockScenario: Equatable, Identifiable {
    /// 正常系レスポンスを返す。
    case success
    /// 全 API でネットワークエラーをシミュレートする。
    case networkError
    /// 任意の HTTP エラーレスポンスを返す。
    case customError(code: Int, message: String, storeUrl: String?)

    var id: String {
        switch self {
        case .success: return "success"
        case .networkError: return "networkError"
        case let .customError(code, _, _): return "error-\(code)"
        }
    }

    // MARK: - プリセット

    static let sessionExpired = MockScenario.customError(code: 401, message: "Unauthorized", storeUrl: nil)
    static let forceUpdate = MockScenario.customError(
        code: 426,
        message: "Upgrade Required",
        storeUrl: "https://apps.apple.com"
    )
    static let serverError = MockScenario.customError(code: 500, message: "Internal Server Error", storeUrl: nil)
    static let forbidden = MockScenario.customError(code: 403, message: "Forbidden", storeUrl: nil)
    static let notFound = MockScenario.customError(code: 404, message: "Not Found", storeUrl: nil)
    static let rateLimited = MockScenario.customError(code: 429, message: "Too Many Requests", storeUrl: nil)
    static let maintenance = MockScenario.customError(code: 503, message: "Service Unavailable", storeUrl: nil)

    /// ボトムシートに表示するプリセット一覧。
    static let presets: [(label: String, scenario: MockScenario)] = [
        ("正常系レスポンス", .success),
        ("セッション切れ (401)", .sessionExpired),
        ("強制アップデート (426)", .forceUpdate),
        ("権限なし (403)", .forbidden),
        ("Not Found (404)", .notFound),
        ("レート制限 (429)", .rateLimited),
        ("サーバーエラー (500)", .serverError),
        ("メンテナンス (503)", .maintenance),
        ("ネットワークエラー", .networkError),
    ]
}

/// 現在のモックシナリオを保持するホルダー。デバッグビルドのみ使用。
final class MockScenarioHolder: ObservableObject {
    static let shared = MockScenarioHolder()
    @Published var current: MockScenario = .success
    private init() {}
}
