//
//  Strings.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

/// アプリ全体で使用する UI 文字列定数。画面ごとにグルーピングして管理する。
enum Strings {
    enum Common {
        static let retry = "リトライ"
        static let close = "閉じる"
        static let errorTitle = "エラー"
        static let idPrefix = "#"
    }

    enum Error {
        static let networkMessage = "ネットワークに接続できません"
        static let networkSubMessage = "接続を確認してリトライしてください"
        static let sessionExpired = "セッションの有効期限が切れました。再度ログインしてください"
        static let forceUpdate = "新しいバージョンが利用可能です。アップデートしてください"
        static let unknownError = "不明なエラーが発生しました"

        static func serverError(code: Int) -> String {
            "サーバーエラー (\(code))"
        }

        static func notFound(query: String) -> String {
            "「\(query)」に一致するポケモンは見つかりませんでした"
        }
    }

    enum Dialog {
        static let sessionExpiredTitle = "セッション切れ"
        static let sessionExpiredMessage = "セッションの有効期限が切れました。\n再度ログインしてください。"
        static let sessionExpiredButton = "ログイン画面へ"

        static let forceUpdateTitle = "アップデートが必要です"
        static let forceUpdateMessage = "新しいバージョンが利用可能です。\nアプリをアップデートしてください。"
        static let forceUpdateButton = "ストアを開く"
    }

    enum List {
        static let screenTitle = "Pokédex"
        static let searchDescription = "検索"
        static let favoritesDescription = "お気に入り"
    }

    enum Detail {
        static let infoButtonDescription = "詳細情報を表示"
        static let removeFavoriteDescription = "お気に入りから削除"
        static let addFavoriteDescription = "お気に入りに追加"
        static let bottomSheetTitle = "くわしい情報"
        static let labelCategory = "分類"
        static let labelGeneration = "世代"
        static let labelHabitat = "生息地"
        static let labelCaptureRate = "捕獲率"
        static let labelEggGroup = "タマゴグループ"
        static let labelGenderRatio = "性別比率"
        static let labelNoGender = "性別なし"
        static let labelAbilities = "とくせい"
        static let labelHiddenAbility = "かくれとくせい"
        static let labelBaseExperience = "きそけいけんち"
        static let sectionEvolution = "しんか"
        static let sectionBaseStats = "しゅぞくち"
        static let eggGroupSeparator = "、"
        static let labelHeight = "たかさ"
        static let labelWeight = "おもさ"
        static let unitCm = "cm"
        static let unitKg = "kg"
        static let evolutionArrow = "→"
        static let evolutionLevelPrefix = "Lv."
        static let genderFemale = "♀"
        static let genderMale = "♂"

        static func heightWeight(heightCm: Int, weightKg: Double) -> String {
            "\(labelHeight): \(heightCm) \(unitCm) ・ \(labelWeight): \(weightKg) \(unitKg)"
        }

        static func genderRatio(femalePercent: Double, malePercent: Double) -> String {
            "\(genderFemale) \(femalePercent)% / \(genderMale) \(malePercent)%"
        }
    }

    enum Search {
        static let searchPlaceholder = "ポケモン名を入力..."
        static let searchIdleMessage = "ポケモン名を入力してください"
    }

    enum Favorites {
        static let screenTitle = "お気に入り"
        static let emptyMessage = "お気に入りがありません"
        static let emptySubMessage = "詳細画面のハートアイコンから追加できます"
    }

    enum Mock {
        static let screenTitle = "Mock Scenario"
        static let sectionHeader = "発生させたいエラーを選択してください。"
        static let labelSuccess = "正常系レスポンス"
        static let labelSessionExpired = "セッション切れ (401)"
        static let labelForceUpdate = "強制アップデート (426)"
        static let labelForbidden = "権限なし (403)"
        static let labelNotFound = "Not Found (404)"
        static let labelRateLimited = "レート制限 (429)"
        static let labelServerError = "サーバーエラー (500)"
        static let labelMaintenance = "メンテナンス (503)"
        static let labelNetworkError = "ネットワークエラー"
    }

    enum Translation {
        private static let types: [String: String] = [
            "normal": "ノーマル", "fire": "ほのお", "water": "みず",
            "electric": "でんき", "grass": "くさ", "ice": "こおり",
            "fighting": "かくとう", "poison": "どく", "ground": "じめん",
            "flying": "ひこう", "psychic": "エスパー", "bug": "むし",
            "rock": "いわ", "ghost": "ゴースト", "dragon": "ドラゴン",
            "dark": "あく", "steel": "はがね", "fairy": "フェアリー",
        ]

        private static let stats: [String: String] = [
            "hp": "HP", "attack": "こうげき", "defense": "ぼうぎょ",
            "special-attack": "とくこう", "special-defense": "とくぼう", "speed": "すばやさ",
        ]

        private static let eggGroups: [String: String] = [
            "monster": "かいじゅう", "water1": "すいちゅう1", "water2": "すいちゅう2",
            "water3": "すいちゅう3", "bug": "むし", "flying": "ひこう",
            "ground": "りくじょう", "fairy": "ようせい", "plant": "しょくぶつ",
            "humanshape": "ひとがた", "mineral": "こうぶつ", "indeterminate": "ふていけい",
            "ditto": "メタモン", "dragon": "ドラゴン", "no-eggs": "タマゴ未発見",
        ]

        private static let habitats: [String: String] = [
            "cave": "どうくつ", "forest": "もり", "grassland": "そうげん",
            "mountain": "やま", "rare": "きちょう", "rough-terrain": "あれち",
            "sea": "うみ", "urban": "まち", "waters-edge": "みずべ",
        ]

        private static let generations: [String: String] = [
            "generation-i": "第1世代", "generation-ii": "第2世代", "generation-iii": "第3世代",
            "generation-iv": "第4世代", "generation-v": "第5世代", "generation-vi": "第6世代",
            "generation-vii": "第7世代", "generation-viii": "第8世代", "generation-ix": "第9世代",
        ]

        static func type(_ key: String) -> String {
            types[key] ?? key
        }

        static func stat(_ key: String) -> String {
            stats[key] ?? key
        }

        static func eggGroup(_ key: String) -> String {
            eggGroups[key] ?? key
        }

        static func habitat(_ key: String) -> String {
            habitats[key] ?? key
        }

        static func generation(_ key: String) -> String {
            generations[key] ?? key
        }
    }
}
