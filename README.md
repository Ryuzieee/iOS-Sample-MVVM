# iOS-Sample-MVVM

PokeAPI を使った iOS ポケモン図鑑アプリ。[Android版](https://github.com/Ryuzieee/Android-Sample-MVVM)と同じ構成。

## 技術スタック

| カテゴリ | 採用技術 |
|---------|---------|
| UI | SwiftUI |
| アーキテクチャ | MVVM + Clean Architecture |
| 状態管理 | ObservableObject + @Published |
| 非同期 | async/await + Task |
| ネットワーク | URLSession |
| ローカルDB | CoreData |
| キャッシュ期限管理 | UserDefaults |
| 画像 | AsyncImage（iOS 15〜標準） |
| DI | イニシャライザDI（Protocol ベース） |
| ログ | OSLog (AppLogger) |
| フォーマット | SwiftFormat |
| 静的解析 | SwiftLint |
| テスト | XCTest + Mock |
| 最小OS | iOS 15 |

## アーキテクチャ

```
App/                    # エントリーポイント, ナビゲーション, DI
Core/
  Domain/               # Model, Repository Protocol, UseCase
  Data/
    API/                # PokeAPIClient, Response DTO
    API/Mock/           # MockAPIClient, MockScenario, シナリオ切替UI
    Local/              # CoreData (FavoriteCoreDataStore)
    Mapper/             # Response → Model 変換
    Repository/         # Repository 実装
    Util/               # RepositoryHandler, CacheConfig, AppLogger
  UI/
    Component/          # 共通UIコンポーネント (UiStateContent, ErrorDialog, etc.)
    Util/               # LoadAsUiState
    Strings.swift       # 文字列定数
Feature/
  List/                 # ポケモン一覧（無限スクロール）
  Detail/               # ポケモン詳細（ステータス, 進化チェーン, お気に入り）
  Search/               # リアルタイム検索（500msデバウンス）
  Favorites/            # お気に入り一覧
```

## テスト

Mapper / UseCase / ViewModel / Repository 実装の4層をカバー。Protocol ベースの Mock を使ったユニットテスト。

## ビルドバリアント

| Scheme | 説明 |
|--------|------|
| `iOS-Sample-MVVM` | 本番 API を使用する通常ビルド |
| `iOS-Sample-MVVM-Mock` | MockAPIClient を使用。画面右下の🐞ボタンからシナリオ切替可能 |

Mock スキームでは正常系 / ネットワークエラー / 各種 HTTP エラー（401, 403, 404, 426, 429, 500, 503）を切り替えてテストできる。

## コード品質

Xcode の Build Phase に SwiftFormat + SwiftLint を組み込み済み。ビルド（⌘B）するだけで自動フォーマット＆静的解析が走る。

| コマンド | 説明 | Android 相当 |
|---------|------|-------------|
| `make format` | SwiftFormat で自動フォーマット | `./gradlew ktlintFormat` |
| `make lint` | SwiftLint で静的解析 | `./gradlew detekt` |
| `make check` | format + lint を順に実行 | - |

## API

[PokeAPI v2](https://pokeapi.co/api/v2/) を使用。
