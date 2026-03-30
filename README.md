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

## デバッグ機能

DEBUGビルド時、一覧画面左上の🐞アイコンから Mock シナリオセレクターを開き、API レスポンスを切り替え可能（正常系 / ネットワークエラー / 各種 HTTP エラー）。

## API

[PokeAPI v2](https://pokeapi.co/api/v2/) を使用。
