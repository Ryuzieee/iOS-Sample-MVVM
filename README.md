# iOS-Sample-MVVM

PokeAPI を使ったポケモン図鑑アプリ。[Android版](https://github.com/Ryuzieee/Android-Sample-MVVM)と同じ構成で、Clean Architecture・SwiftUI・Protocol ベース DI を組み合わせた iOS サンプルプロジェクト。

---

## 画面

| 一覧画面 | 詳細画面 | 検索画面 | お気に入り画面 |
|---------|---------|---------|------------|
| ポケモンを2列グリッドで無限スクロール表示（自前ページネーション） | タイプ・ステータス・進化チェーン・詳細情報をスクロール表示。ハートアイコンでお気に入りトグル | ポケモン名でリアルタイム検索（500ms デバウンス） | お気に入り登録ポケモンを2列グリッドで表示 |

---

## 技術スタック

| カテゴリ | 採用技術 |
|---------|---------|
| **Language** | Swift 5.9 |
| **UI** | SwiftUI |
| **アーキテクチャ** | MVVM + Clean Architecture |
| **状態管理** | ObservableObject + @Published |
| **非同期** | async/await + Task（@MainActor） |
| **ネットワーク** | URLSession |
| **ローカルDB** | CoreData（お気に入り） / Codable + FileManager（キャッシュ） |
| **画像** | AsyncImage（iOS 15〜標準） |
| **DI** | イニシャライザ DI（Protocol ベース） |
| **ログ** | OSLog (AppLogger) |
| **フォーマット** | SwiftFormat |
| **静的解析** | SwiftLint |
| **テスト** | XCTest + Mock |
| **最小OS** | iOS 15 |

---

## アーキテクチャ

Clean Architecture + MVVM。シングルターゲット構成でシンプルに保ちつつ、フォルダで責務を分離。

```
┌──────────────────────────────────────────────┐
│                     App                       │  エントリポイント・ナビゲーション・DI
├──────────────────────────────────────────────┤
│                   Feature                     │  画面単位の UI・ViewModel
│   List / Detail / Search / Favorites          │  （フォルダで分離）
├──────────────────────────────────────────────┤
│                    Core                       │  ドメイン・データ・共通 UI
│   Domain / Data / UI                          │  （フォルダで分離）
└──────────────────────────────────────────────┘
```

### フォルダ構成

#### `Core/Domain`（ビジネスロジック）
- **Model**: `PokemonDetailModel`, `PokemonSpeciesModel`, `EvolutionStageModel`, `FavoriteModel`, `PokemonSummaryModel`, `AppError`, `ErrorType`
- **Repository Protocol**: `PokemonRepositoryProtocol`, `FavoriteRepositoryProtocol`
- **UseCase**: `GetPokemonListUseCase`, `GetPokemonFullDetailUseCase`, `SearchPokemonUseCase`, `GetFavoritesUseCase`, `GetIsFavoriteUseCase`, `ToggleFavoriteUseCase`（`callAsFunction` で関数的に呼び出し）

> ViewModel → UseCase → Repository の一方向データフローを統一。

#### `Core/Data`（データ層）
- **API**: URLSession で PokeAPI を呼び出し（`PokeAPIClient` / `PokeAPIClientProtocol`）
- **Cache**: Codable + FileManager でキャッシュ（debug: 1分 / release: 5分）。`CachedEntry<T>` でタイムスタンプ管理
- **Local**: CoreData でお気に入りを永続化（`FavoriteCoreDataStore` / `FavoriteStoreProtocol`）
- **Mapper**: `Data/Mapper/` フォルダに集約。ドメインモデルやレスポンス型の extension（`init(from:)`）で変換を定義
- **Repository Handler**: `handleWithCache` / `handleRemote` / `handleLocal` で例外を `AppError` に変換

#### `Core/UI`（共通 UI）
- **コンポーネント**: `EmptyContent`, `ErrorContent`, `LoadingIndicator`, `PokemonGrid`, `PokemonImage`, `SearchTextField`, `ErrorDialog`, `PokemonTextComponents`, `AppIconButton`
- **文字列定数**: `Strings.swift` にアプリ全体の UI 文字列を画面ごとにグルーピング
- **ユーティリティ**: `UiState`（Idle / Loading / Success / Error）、`loadAsUiState` 関数

#### `Feature`（各画面）
- 各 ViewModel は `@MainActor` + `ObservableObject` を採用し `@Published` で状態管理
- UI 状態は `UiState` enum を各画面で `switch` して描画
- `Search`: Combine `debounce(500ms)` でデバウンス検索
- `Favorites`: Pull-to-refresh 対応
- `Detail`: 進化チェーン表示、詳細情報セクション、お気に入りトグル

### データフロー

```
UI (SwiftUI View)
  └─ ViewModel (@Published)
       └─ UseCase
            └─ Repository Protocol
                 └─ RepositoryImpl
                      ├─ PokeAPIClient (URLSession)
                      ├─ PokemonCacheStore (FileManager Cache)
                      └─ FavoriteCoreDataStore (CoreData)
```

---

## ナビゲーション

NavigationStack（iOS 16+）による型安全ルーティング。

```swift
// ルート定義
enum Route: Hashable {
    case detail(String)
}

// 遷移
path.append(.detail(pokemonName))
```

| 遷移方式 | アニメーション | 用途 |
|---------|-------------|------|
| NavigationStack push | 水平スライド（iOS 標準） | 一覧 → 詳細など通常遷移 |
| `.sheet()` | 下から上スライド（iOS 標準） | 検索・お気に入りなどモーダル的遷移 |

検索・お気に入りの sheet 内にも独自の NavigationStack を持ち、詳細画面へ push 遷移できる。戻るボタンで元の画面に復帰する。

---

## キャッシュ戦略

詳細画面は **Local-First** パターンで実装。

```
getPokemonDetail(name) の呼び出し時:
  1. FileManager から該当データを取得
  2. キャッシュが存在 かつ 有効期間内 → キャッシュを返す
     （debug: 1分 / release: 5分）
  3. それ以外 → API から取得 → Codable で変換 → ファイルに保存 → Model で返す
```

`handleWithCache` は `fetch` → `toEntity` → `save` + `toModel` のパイプラインを一元管理し、例外を `AppError` に変換する。

---

## ビルドバリアント

| Scheme | Configuration | 用途 |
|--------|--------------|------|
| `iOS-Sample-MVVM` | Debug / Release | 本番 API を使用する通常ビルド |
| `iOS-Sample-MVVM-Mock` | Debug-Mock | MockAPIClient を使用。画面右下の🐞ボタンからシナリオ切替可能 |

Mock スキームでは正常系 / ネットワークエラー / 各種 HTTP エラー（401, 403, 404, 426, 429, 500, 503）を切り替えてテストできる。

---

## テスト

```bash
# Xcode から実行
⌘U（Product → Test）
```

| レイヤー | テストクラス | ツール |
|---------|------------|--------|
| **Mapper** | `PokemonDetailMapperTests`, `PokemonSpeciesMapperTests`, `EvolutionChainMapperTests`, `AbilityMapperTests`, `PokemonNameMapperTests` | XCTest |
| **Repository** | `PokemonRepositoryImplTests`, `FavoriteRepositoryImplTests` | XCTest + Mock |
| **ViewModel** | `PokemonListViewModelTests`, `PokemonDetailViewModelTests`, `SearchViewModelTests`, `FavoritesViewModelTests` | XCTest + Mock |

---

## セットアップ

### 必要環境

- Xcode 15 以上（推奨: 最新版）
- iOS 15 以上

### ビルド

```bash
# Xcode から
⌘B（Build）  # SwiftFormat + SwiftLint が自動実行される

# コマンドラインから
xcodebuild -scheme iOS-Sample-MVVM-Mock -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

### コード品質

```bash
# フォーマット自動修正
make format

# 静的解析
make lint

# format + lint を順に実行
make check
```

> **Note**: Xcode の Build Phase に SwiftFormat + SwiftLint を組み込み済み。ビルド（⌘B）するだけで自動フォーマット＆静的解析が走る。

---

## API

[PokeAPI v2](https://pokeapi.co/) を使用。認証不要・無料。

| エンドポイント | 用途 |
|-------------|------|
| `GET /pokemon?limit={n}&offset={m}` | ポケモン一覧取得（ページング） |
| `GET /pokemon/{name}` | ポケモン詳細取得 |
| `GET /pokemon-species/{name}` | 種族情報（日本語名・分類・世代等） |
| `GET /evolution-chain/{id}` | 進化チェーン取得 |
| `GET /ability/{id}` | とくせい（日本語名）取得 |
