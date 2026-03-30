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
| DI | イニシャライザDI |
| テスト | XCTest + Mock |
| 最小OS | iOS 15 |

## アーキテクチャ

```
App/                    # エントリーポイント, ナビゲーション, DI
Core/
  Domain/               # Model, Repository Protocol, UseCase
  Data/                 # API, CoreData, Mapper, Repository実装
  UI/Component/         # 共通UIコンポーネント
Feature/
  List/                 # ポケモン一覧（無限スクロール）
  Detail/               # ポケモン詳細（ステータス, 進化チェーン, お気に入り）
  Search/               # リアルタイム検索（500msデバウンス）
  Favorites/            # お気に入り一覧
```

## テスト

Mapper / UseCase / ViewModel の3層をカバー。Mock Repositoryを使ったユニットテスト。

## API

[PokeAPI v2](https://pokeapi.co/api/v2/) を使用。
