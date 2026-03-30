//
//  MockPokemons.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

// swiftlint:disable file_length type_body_length

import Foundation

/// モック用ポケモンデータの元定義。各レスポンスビルダーから参照される。
struct MockPokemon {
    let id: Int
    let name: String
    let jaName: String
    let height: Int
    let weight: Int
    let baseExperience: Int
    let types: [String]
    let abilities: [String]
    let hiddenAbility: String?
    let hp: Int
    let attack: Int
    let defense: Int
    let spAttack: Int
    let spDefense: Int
    let speed: Int
    let genus: String
    let flavorText: String
    let habitat: String?
    let generation: String
    let eggGroups: [String]
    let genderRate: Int
    let captureRate: Int
    let evolutionChainId: Int
}

// MARK: - Pokemon Data

/// Android 版 MockPokemons.kt と同等のモックポケモン一覧。
enum MockPokemons {
    // swiftlint:disable:next function_body_length
    static let all: [MockPokemon] = [
        // ── フシギダネ系 (chain 1) ──
        MockPokemon(
            id: 1, name: "bulbasaur", jaName: "フシギダネ",
            height: 7, weight: 69, baseExperience: 64,
            types: ["grass", "poison"], abilities: ["overgrow"], hiddenAbility: "chlorophyll",
            hp: 45, attack: 49, defense: 49, spAttack: 65, spDefense: 65, speed: 45,
            genus: "たねポケモン",
            flavorText: "うまれたときから　せなかに\nふしぎな　タネが　うえてあり\nからだと　ともに　そだつという。",
            habitat: "grassland", generation: "generation-i",
            eggGroups: ["monster", "grass"], genderRate: 1, captureRate: 45, evolutionChainId: 1
        ),
        MockPokemon(
            id: 2, name: "ivysaur", jaName: "フシギソウ",
            height: 10, weight: 130, baseExperience: 142,
            types: ["grass", "poison"], abilities: ["overgrow"], hiddenAbility: "chlorophyll",
            hp: 60, attack: 62, defense: 63, spAttack: 80, spDefense: 80, speed: 60,
            genus: "たねポケモン",
            flavorText: "つぼみが　せなかに　ついていて\nようぶんを　きゅうしゅうしていくと\nおおきな　はなが　さくという。",
            habitat: "grassland", generation: "generation-i",
            eggGroups: ["monster", "grass"], genderRate: 1, captureRate: 45, evolutionChainId: 1
        ),
        MockPokemon(
            id: 3, name: "venusaur", jaName: "フシギバナ",
            height: 20, weight: 1000, baseExperience: 263,
            types: ["grass", "poison"], abilities: ["overgrow"], hiddenAbility: "chlorophyll",
            hp: 80, attack: 82, defense: 83, spAttack: 100, spDefense: 100, speed: 80,
            genus: "たねポケモン",
            flavorText: "はなから　うっとりする　かおりが\nただよい　たたかう　ものの\nきもちを　なだめてしまう。",
            habitat: "grassland", generation: "generation-i",
            eggGroups: ["monster", "grass"], genderRate: 1, captureRate: 45, evolutionChainId: 1
        ),
        // ── ヒトカゲ系 (chain 2) ──
        MockPokemon(
            id: 4, name: "charmander", jaName: "ヒトカゲ",
            height: 6, weight: 85, baseExperience: 62,
            types: ["fire"], abilities: ["blaze"], hiddenAbility: "solar-power",
            hp: 39, attack: 52, defense: 43, spAttack: 60, spDefense: 50, speed: 65,
            genus: "とかげポケモン",
            flavorText: "うまれたときから　しっぽに\nほのおが　ともっている。ほのおが\nきえたとき　その　いのちは　おわる。",
            habitat: "mountain", generation: "generation-i",
            eggGroups: ["monster", "dragon"], genderRate: 1, captureRate: 45, evolutionChainId: 2
        ),
        MockPokemon(
            id: 5, name: "charmeleon", jaName: "リザード",
            height: 11, weight: 190, baseExperience: 142,
            types: ["fire"], abilities: ["blaze"], hiddenAbility: "solar-power",
            hp: 58, attack: 64, defense: 58, spAttack: 80, spDefense: 65, speed: 80,
            genus: "かえんポケモン",
            flavorText: "たたかいで　きぶんが　たかまると\nしっぽの　さきから　あかるい\nほのおを　ふきだす　らんぼうもの。",
            habitat: "mountain", generation: "generation-i",
            eggGroups: ["monster", "dragon"], genderRate: 1, captureRate: 45, evolutionChainId: 2
        ),
        MockPokemon(
            id: 6, name: "charizard", jaName: "リザードン",
            height: 17, weight: 905, baseExperience: 267,
            types: ["fire", "flying"], abilities: ["blaze"], hiddenAbility: "solar-power",
            hp: 78, attack: 84, defense: 78, spAttack: 109, spDefense: 85, speed: 100,
            genus: "かえんポケモン",
            flavorText: "ちきゅうじょうの　あらゆるものを\nやきつくす　ほのおを　はける。\nもりかじの　げんいんに　なる。",
            habitat: "mountain", generation: "generation-i",
            eggGroups: ["monster", "dragon"], genderRate: 1, captureRate: 45, evolutionChainId: 2
        ),
        // ── ゼニガメ系 (chain 3) ──
        MockPokemon(
            id: 7, name: "squirtle", jaName: "ゼニガメ",
            height: 5, weight: 90, baseExperience: 63,
            types: ["water"], abilities: ["torrent"], hiddenAbility: "rain-dish",
            hp: 44, attack: 48, defense: 65, spAttack: 50, spDefense: 64, speed: 43,
            genus: "かめのこポケモン",
            flavorText: "うまれると　せなかの　コウラが\nふくらんで　かたくなる。くちから\nいきおいよく　あわを　ふく。",
            habitat: "waters-edge", generation: "generation-i",
            eggGroups: ["monster", "water1"], genderRate: 1, captureRate: 45, evolutionChainId: 3
        ),
        MockPokemon(
            id: 8, name: "wartortle", jaName: "カメール",
            height: 10, weight: 225, baseExperience: 142,
            types: ["water"], abilities: ["torrent"], hiddenAbility: "rain-dish",
            hp: 59, attack: 63, defense: 80, spAttack: 65, spDefense: 80, speed: 58,
            genus: "かめポケモン",
            flavorText: "ながいきの　シンボルとして\nにんきが　ある。ふさふさの　みみと\nしっぽの　けが　ながいきの　しょうこ。",
            habitat: "waters-edge", generation: "generation-i",
            eggGroups: ["monster", "water1"], genderRate: 1, captureRate: 45, evolutionChainId: 3
        ),
        MockPokemon(
            id: 9, name: "blastoise", jaName: "カメックス",
            height: 16, weight: 855, baseExperience: 265,
            types: ["water"], abilities: ["torrent"], hiddenAbility: "rain-dish",
            hp: 79, attack: 83, defense: 100, spAttack: 85, spDefense: 105, speed: 78,
            genus: "こうらポケモン",
            flavorText: "こうらの　ロケットほうから\nふきだす　みずは　はがねの いたも\nぶちぬく　はかいりょくだ。",
            habitat: "waters-edge", generation: "generation-i",
            eggGroups: ["monster", "water1"], genderRate: 1, captureRate: 45, evolutionChainId: 3
        ),
        // ── ピカチュウ系 (chain 10) ──
        MockPokemon(
            id: 172, name: "pichu", jaName: "ピチュー",
            height: 3, weight: 20, baseExperience: 41,
            types: ["electric"], abilities: ["static"], hiddenAbility: "lightning-rod",
            hp: 20, attack: 40, defense: 15, spAttack: 35, spDefense: 35, speed: 60,
            genus: "こねずみポケモン",
            flavorText: "かみなりぐもが　でると　なかまの\nピチューどうしで　でんきを\nおくりあって　あそぶ　すがたが　みられる。",
            habitat: "forest", generation: "generation-ii",
            eggGroups: ["undiscovered"], genderRate: 4, captureRate: 190, evolutionChainId: 10
        ),
        MockPokemon(
            id: 25, name: "pikachu", jaName: "ピカチュウ",
            height: 4, weight: 60, baseExperience: 112,
            types: ["electric"], abilities: ["static"], hiddenAbility: "lightning-rod",
            hp: 35, attack: 55, defense: 40, spAttack: 50, spDefense: 50, speed: 90,
            genus: "ねずみポケモン",
            flavorText: "ほっぺたの　でんきぶくろに\nでんきを　ためている。ピンチのとき\nに　ほうでんする。",
            habitat: "forest", generation: "generation-i",
            eggGroups: ["field", "fairy"], genderRate: 4, captureRate: 190, evolutionChainId: 10
        ),
        MockPokemon(
            id: 26, name: "raichu", jaName: "ライチュウ",
            height: 8, weight: 300, baseExperience: 243,
            types: ["electric"], abilities: ["static"], hiddenAbility: "lightning-rod",
            hp: 60, attack: 90, defense: 55, spAttack: 90, spDefense: 80, speed: 110,
            genus: "ねずみポケモン",
            flavorText: "でんきを　ためすぎて　こうふんすると\nかがやく。くらやみで　ひかる。",
            habitat: "forest", generation: "generation-i",
            eggGroups: ["field", "fairy"], genderRate: 4, captureRate: 75, evolutionChainId: 10
        ),
        // ── イーブイ系 (chain 67) ──
        MockPokemon(
            id: 133, name: "eevee", jaName: "イーブイ",
            height: 3, weight: 65, baseExperience: 65,
            types: ["normal"], abilities: ["run-away", "adaptability"], hiddenAbility: "anticipation",
            hp: 55, attack: 55, defense: 50, spAttack: 45, spDefense: 65, speed: 55,
            genus: "しんかポケモン",
            flavorText: "ふきそくな　いでんしを\nもっている。いしの　ほうしゃせんで\nからだが　とつぜんへんいする。",
            habitat: "urban", generation: "generation-i",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 134, name: "vaporeon", jaName: "シャワーズ",
            height: 10, weight: 290, baseExperience: 184,
            types: ["water"], abilities: ["water-absorb"], hiddenAbility: "hydration",
            hp: 130, attack: 65, defense: 60, spAttack: 110, spDefense: 95, speed: 65,
            genus: "あわはきポケモン",
            flavorText: "からだの　さいぼうが　みずの　ぶんしに\nにている。みずに　とけると\nすがたが　みえなくなる。",
            habitat: "urban", generation: "generation-i",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 135, name: "jolteon", jaName: "サンダース",
            height: 8, weight: 245, baseExperience: 184,
            types: ["electric"], abilities: ["volt-absorb"], hiddenAbility: "quick-feet",
            hp: 65, attack: 65, defense: 60, spAttack: 110, spDefense: 95, speed: 130,
            genus: "かみなりポケモン",
            flavorText: "おこったり　おどろいたりすると\nぜんしんの　けが　はりのように\nさかだって　あいてを　つらぬく。",
            habitat: "urban", generation: "generation-i",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 136, name: "flareon", jaName: "ブースター",
            height: 9, weight: 250, baseExperience: 184,
            types: ["fire"], abilities: ["flash-fire"], hiddenAbility: "guts",
            hp: 65, attack: 130, defense: 60, spAttack: 95, spDefense: 110, speed: 65,
            genus: "ほのおポケモン",
            flavorText: "ふかく　いきを　すいこんでから\nはきだす　ほのおは　1700ど\nにも　たっする。",
            habitat: "urban", generation: "generation-i",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 196, name: "espeon", jaName: "エーフィ",
            height: 9, weight: 265, baseExperience: 184,
            types: ["psychic"], abilities: ["synchronize"], hiddenAbility: "magic-bounce",
            hp: 65, attack: 65, defense: 60, spAttack: 130, spDefense: 95, speed: 110,
            genus: "たいようポケモン",
            flavorText: "トレーナーに　ちゅうじつ。\nよちのうりょくを　はったつ　させたのは\nトレーナーを　きけんから　まもるため。",
            habitat: "urban", generation: "generation-ii",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 197, name: "umbreon", jaName: "ブラッキー",
            height: 10, weight: 270, baseExperience: 184,
            types: ["dark"], abilities: ["synchronize"], hiddenAbility: "inner-focus",
            hp: 95, attack: 65, defense: 110, spAttack: 60, spDefense: 130, speed: 65,
            genus: "げっこうポケモン",
            flavorText: "つきの　はどうを　あびて\nしんかした。やみに　ひそみ\nえものを　まつ。",
            habitat: "urban", generation: "generation-ii",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 470, name: "leafeon", jaName: "リーフィア",
            height: 10, weight: 255, baseExperience: 184,
            types: ["grass"], abilities: ["leaf-guard"], hiddenAbility: "chlorophyll",
            hp: 65, attack: 110, defense: 130, spAttack: 60, spDefense: 65, speed: 95,
            genus: "しんりょくポケモン",
            flavorText: "こけの　ついた　いわの　ちかくで\nイーブイを　しんかさせると\nリーフィアに　なる。",
            habitat: "urban", generation: "generation-iv",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 471, name: "glaceon", jaName: "グレイシア",
            height: 8, weight: 259, baseExperience: 184,
            types: ["ice"], abilities: ["snow-cloak"], hiddenAbility: "ice-body",
            hp: 65, attack: 60, defense: 110, spAttack: 130, spDefense: 95, speed: 65,
            genus: "しんせつポケモン",
            flavorText: "たいおんを　さげることで\nまわりの　くうきを　こおらせ\nダイヤモンドダストを　つくる。",
            habitat: "urban", generation: "generation-iv",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        MockPokemon(
            id: 700, name: "sylveon", jaName: "ニンフィア",
            height: 10, weight: 235, baseExperience: 184,
            types: ["fairy"], abilities: ["cute-charm"], hiddenAbility: "pixilate",
            hp: 95, attack: 65, defense: 65, spAttack: 110, spDefense: 130, speed: 60,
            genus: "むすびつきポケモン",
            flavorText: "リボンのような　てんしょくきを\nからませ　あいての　てきいを\nしずめて　しんゆうを　やめさせる。",
            habitat: "urban", generation: "generation-vi",
            eggGroups: ["field"], genderRate: 1, captureRate: 45, evolutionChainId: 67
        ),
        // ── カビゴン系 (chain 72) ──
        MockPokemon(
            id: 446, name: "munchlax", jaName: "ゴンベ",
            height: 6, weight: 1050, baseExperience: 78,
            types: ["normal"], abilities: ["pickup", "thick-fat"], hiddenAbility: "gluttony",
            hp: 135, attack: 85, defense: 40, spAttack: 40, spDefense: 85, speed: 5,
            genus: "おおぐいポケモン",
            flavorText: "じぶんの　たいじゅうと\nおなじ　りょうの　たべものを\nまいにち　たべないと　きが　すまない。",
            habitat: "mountain", generation: "generation-iv",
            eggGroups: ["undiscovered"], genderRate: 1, captureRate: 50, evolutionChainId: 72
        ),
        MockPokemon(
            id: 143, name: "snorlax", jaName: "カビゴン",
            height: 21, weight: 4600, baseExperience: 189,
            types: ["normal"], abilities: ["immunity", "thick-fat"], hiddenAbility: "gluttony",
            hp: 160, attack: 110, defense: 65, spAttack: 65, spDefense: 110, speed: 30,
            genus: "いねむりポケモン",
            flavorText: "いちにちに　たべものを\n400キロ　たべないと\nきが　すまない。たべおわると　ねむる。",
            habitat: "mountain", generation: "generation-i",
            eggGroups: ["monster"], genderRate: 1, captureRate: 25, evolutionChainId: 72
        ),
        // ── ミュウツー (chain 77, 進化なし) ──
        MockPokemon(
            id: 150, name: "mewtwo", jaName: "ミュウツー",
            height: 20, weight: 1220, baseExperience: 340,
            types: ["psychic"], abilities: ["pressure"], hiddenAbility: "unnerve",
            hp: 106, attack: 110, defense: 90, spAttack: 154, spDefense: 90, speed: 130,
            genus: "いでんしポケモン",
            flavorText: "いでんし　そうさによって\nつくられた　ポケモン。にんげんの\nかがくりょくで　からだは　つくれても\nやさしい　こころを　つくることは　できなかった。",
            habitat: "rare", generation: "generation-i",
            eggGroups: ["undiscovered"], genderRate: -1, captureRate: 3, evolutionChainId: 77
        ),
        // ── ミュウ (chain 78, 進化なし) ──
        MockPokemon(
            id: 151, name: "mew", jaName: "ミュウ",
            height: 4, weight: 40, baseExperience: 300,
            types: ["psychic"], abilities: ["synchronize"], hiddenAbility: nil,
            hp: 100, attack: 100, defense: 100, spAttack: 100, spDefense: 100, speed: 100,
            genus: "しんしゅポケモン",
            flavorText: "すべての　ポケモンの　いでんしを\nもつと　いわれている。あらゆる\nわざを　つかうことが　できる。",
            habitat: "rare", generation: "generation-i",
            eggGroups: ["undiscovered"], genderRate: -1, captureRate: 45, evolutionChainId: 78
        ),
        // ── ルギア (chain 131, 進化なし) ──
        MockPokemon(
            id: 249, name: "lugia", jaName: "ルギア",
            height: 52, weight: 2160, baseExperience: 340,
            types: ["psychic", "flying"], abilities: ["pressure"], hiddenAbility: "multiscale",
            hp: 106, attack: 90, defense: 130, spAttack: 90, spDefense: 154, speed: 110,
            genus: "せんすいポケモン",
            flavorText: "あまりにも　つよすぎる　ちからを\nもつため　ふかい　うみのそこで\nしずかに　ときを　すごしている。",
            habitat: "sea", generation: "generation-ii",
            eggGroups: ["undiscovered"], genderRate: -1, captureRate: 3, evolutionChainId: 131
        ),
        // ── レックウザ (chain 209, 進化なし) ──
        MockPokemon(
            id: 384, name: "rayquaza", jaName: "レックウザ",
            height: 70, weight: 2065, baseExperience: 340,
            types: ["dragon", "flying"], abilities: ["air-lock"], hiddenAbility: nil,
            hp: 105, attack: 150, defense: 90, spAttack: 150, spDefense: 90, speed: 95,
            genus: "てんくうポケモン",
            flavorText: "オゾンそうの　なかを　なんおくねんも\nとびつづけていた　ポケモン。\nグラードンと　カイオーガの　あらそいを\nしずめたと　いう　でんせつがある。",
            habitat: nil, generation: "generation-iii",
            eggGroups: ["undiscovered"], genderRate: -1, captureRate: 45, evolutionChainId: 209
        ),
        // ── ルカリオ系 (chain 232) ──
        MockPokemon(
            id: 447, name: "riolu", jaName: "リオル",
            height: 7, weight: 202, baseExperience: 57,
            types: ["fighting"], abilities: ["steadfast", "inner-focus"], hiddenAbility: "prankster",
            hp: 40, attack: 70, defense: 40, spAttack: 35, spDefense: 40, speed: 60,
            genus: "はもんポケモン",
            flavorText: "からだから　はっする　はどうの\nかたちで　きもちや　かんがえを\nつたえる　ちからを　もつ。",
            habitat: nil, generation: "generation-iv",
            eggGroups: ["undiscovered"], genderRate: 1, captureRate: 75, evolutionChainId: 232
        ),
        MockPokemon(
            id: 448, name: "lucario", jaName: "ルカリオ",
            height: 12, weight: 540, baseExperience: 184,
            types: ["fighting", "steel"], abilities: ["steadfast", "inner-focus"], hiddenAbility: "justified",
            hp: 70, attack: 110, defense: 70, spAttack: 115, spDefense: 70, speed: 90,
            genus: "はどうポケモン",
            flavorText: "あらゆる　ものが　はっする\nはどうを　キャッチする　のうりょくを\nもつ。にんげんの　ことばも　わかる。",
            habitat: nil, generation: "generation-iv",
            eggGroups: ["field", "human-like"], genderRate: 1, captureRate: 45, evolutionChainId: 232
        ),
        // ── ゲッコウガ系 (chain 331) ──
        MockPokemon(
            id: 656, name: "froakie", jaName: "ケロマツ",
            height: 3, weight: 70, baseExperience: 63,
            types: ["water"], abilities: ["torrent"], hiddenAbility: "protean",
            hp: 41, attack: 56, defense: 40, spAttack: 62, spDefense: 44, speed: 71,
            genus: "あわがえるポケモン",
            flavorText: "むねと　せなかの　あわは\nだんりょくが　あり　あいての\nこうげきから　みを　まもる。",
            habitat: nil, generation: "generation-vi",
            eggGroups: ["water1"], genderRate: 1, captureRate: 45, evolutionChainId: 331
        ),
        MockPokemon(
            id: 657, name: "frogadier", jaName: "ゲコガシラ",
            height: 6, weight: 109, baseExperience: 142,
            types: ["water"], abilities: ["torrent"], hiddenAbility: "protean",
            hp: 54, attack: 63, defense: 52, spAttack: 83, spDefense: 56, speed: 97,
            genus: "あわがえるポケモン",
            flavorText: "かるいみのこなしで　じゅもくを\nのぼり　こうげきする。こいしを\nなげる　ワザの　めいちゅうりつは\nひゃっぱつひゃくちゅう。",
            habitat: nil, generation: "generation-vi",
            eggGroups: ["water1"], genderRate: 1, captureRate: 45, evolutionChainId: 331
        ),
        MockPokemon(
            id: 658, name: "greninja", jaName: "ゲッコウガ",
            height: 15, weight: 400, baseExperience: 239,
            types: ["water", "dark"], abilities: ["torrent"], hiddenAbility: "protean",
            hp: 72, attack: 95, defense: 67, spAttack: 103, spDefense: 71, speed: 122,
            genus: "しのびポケモン",
            flavorText: "にんじゃのように　しんしゅつきぼつ。\nこうそくいどうで　ほんろうしつつ\nみずの　しゅりけんで　きりさく。",
            habitat: nil, generation: "generation-vi",
            eggGroups: ["water1"], genderRate: 1, captureRate: 45, evolutionChainId: 331
        ),
        // ── ミミッキュ (chain 403, 進化なし) ──
        MockPokemon(
            id: 778, name: "mimikyu", jaName: "ミミッキュ",
            height: 2, weight: 7, baseExperience: 167,
            types: ["ghost", "fairy"], abilities: ["disguise"], hiddenAbility: nil,
            hp: 55, attack: 90, defense: 80, spAttack: 50, spDefense: 105, speed: 96,
            genus: "ばけのかわポケモン",
            flavorText: "さびしがりやの　ポケモン。\nピカチュウの　すがたに　ばけると\nなかよく　してもらえると　きいたのだ。",
            habitat: nil, generation: "generation-vii",
            eggGroups: ["amorphous"], genderRate: 4, captureRate: 45, evolutionChainId: 403
        ),
    ]

    static let byName: [String: MockPokemon] = Dictionary(uniqueKeysWithValues: all.map { ($0.name, $0) })
    static let byId: [Int: MockPokemon] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

    // MARK: - Ability Japanese Names

    static let abilityJaNames: [String: String] = [
        "overgrow": "しんりょく",
        "chlorophyll": "ようりょくそ",
        "blaze": "もうか",
        "solar-power": "サンパワー",
        "torrent": "げきりゅう",
        "rain-dish": "あめうけざら",
        "static": "せいでんき",
        "lightning-rod": "ひらいしん",
        "run-away": "にげあし",
        "adaptability": "てきおうりょく",
        "anticipation": "きけんよち",
        "immunity": "めんえき",
        "thick-fat": "あついしぼう",
        "gluttony": "くいしんぼう",
        "pressure": "プレッシャー",
        "unnerve": "きんちょうかん",
        "synchronize": "シンクロ",
        "multiscale": "マルチスケイル",
        "air-lock": "エアロック",
        "steadfast": "ふくつのこころ",
        "inner-focus": "せいしんりょく",
        "justified": "せいぎのこころ",
        "protean": "へんげんじざい",
        "disguise": "ばけのかわ",
        "water-absorb": "ちょすい",
        "hydration": "うるおいボディ",
        "volt-absorb": "ちくでん",
        "quick-feet": "はやあし",
        "flash-fire": "もらいび",
        "guts": "こんじょう",
        "magic-bounce": "マジックミラー",
        "cute-charm": "メロメロボディ",
        "pixilate": "フェアリースキン",
        "leaf-guard": "リーフガード",
        "snow-cloak": "ゆきがくれ",
        "ice-body": "アイスボディ",
        "pickup": "ものひろい",
        "prankster": "いたずらごころ",
    ]

    // MARK: - Evolution Chains

    /// 進化チェーンのマスタ定義。chain ID → EvolutionChainResponse のマップ。
    static let evolutionChains: [Int: EvolutionChainResponse] = {
        func species(_ name: String, _ id: Int) -> EvolutionChainResponse.Species {
            .init(name: name, url: "https://pokeapi.co/api/v2/pokemon-species/\(id)/")
        }
        func levelUp(_ level: Int) -> EvolutionChainResponse.EvolutionDetail {
            .init(minLevel: level, trigger: .init(name: "level-up"))
        }
        func useItem() -> EvolutionChainResponse.EvolutionDetail {
            .init(minLevel: nil, trigger: .init(name: "use-item"))
        }
        func friendship() -> EvolutionChainResponse.EvolutionDetail {
            .init(minLevel: nil, trigger: .init(name: "level-up"))
        }
        func leaf(
            _ species: EvolutionChainResponse.Species,
            evolvesTo: [EvolutionChainResponse.ChainLink] = [],
            details: [EvolutionChainResponse.EvolutionDetail] = []
        ) -> EvolutionChainResponse.ChainLink {
            .init(species: species, evolvesTo: evolvesTo, evolutionDetails: details)
        }

        return [
            // フシギダネ → フシギソウ → フシギバナ
            1: EvolutionChainResponse(id: 1, chain: leaf(species("bulbasaur", 1), evolvesTo: [
                leaf(species("ivysaur", 2), evolvesTo: [
                    leaf(species("venusaur", 3), details: [levelUp(32)]),
                ], details: [levelUp(16)]),
            ])),
            // ヒトカゲ → リザード → リザードン
            2: EvolutionChainResponse(id: 2, chain: leaf(species("charmander", 4), evolvesTo: [
                leaf(species("charmeleon", 5), evolvesTo: [
                    leaf(species("charizard", 6), details: [levelUp(36)]),
                ], details: [levelUp(16)]),
            ])),
            // ゼニガメ → カメール → カメックス
            3: EvolutionChainResponse(id: 3, chain: leaf(species("squirtle", 7), evolvesTo: [
                leaf(species("wartortle", 8), evolvesTo: [
                    leaf(species("blastoise", 9), details: [levelUp(36)]),
                ], details: [levelUp(16)]),
            ])),
            // ピチュー → ピカチュウ → ライチュウ
            10: EvolutionChainResponse(id: 10, chain: leaf(species("pichu", 172), evolvesTo: [
                leaf(species("pikachu", 25), evolvesTo: [
                    leaf(species("raichu", 26), details: [useItem()]),
                ], details: [friendship()]),
            ])),
            // イーブイ → 8分岐進化
            67: EvolutionChainResponse(id: 67, chain: leaf(species("eevee", 133), evolvesTo: [
                leaf(species("vaporeon", 134), details: [useItem()]),
                leaf(species("jolteon", 135), details: [useItem()]),
                leaf(species("flareon", 136), details: [useItem()]),
                leaf(species("espeon", 196), details: [friendship()]),
                leaf(species("umbreon", 197), details: [friendship()]),
                leaf(species("leafeon", 470), details: [useItem()]),
                leaf(species("glaceon", 471), details: [useItem()]),
                leaf(species("sylveon", 700), details: [friendship()]),
            ])),
            // ゴンベ → カビゴン
            72: EvolutionChainResponse(id: 72, chain: leaf(species("munchlax", 446), evolvesTo: [
                leaf(species("snorlax", 143), details: [friendship()]),
            ])),
            // ミュウツー (進化なし)
            77: EvolutionChainResponse(id: 77, chain: leaf(species("mewtwo", 150))),
            // ミュウ (進化なし)
            78: EvolutionChainResponse(id: 78, chain: leaf(species("mew", 151))),
            // ルギア (進化なし)
            131: EvolutionChainResponse(id: 131, chain: leaf(species("lugia", 249))),
            // レックウザ (進化なし)
            209: EvolutionChainResponse(id: 209, chain: leaf(species("rayquaza", 384))),
            // リオル → ルカリオ
            232: EvolutionChainResponse(id: 232, chain: leaf(species("riolu", 447), evolvesTo: [
                leaf(species("lucario", 448), details: [friendship()]),
            ])),
            // ケロマツ → ゲコガシラ → ゲッコウガ
            331: EvolutionChainResponse(id: 331, chain: leaf(species("froakie", 656), evolvesTo: [
                leaf(species("frogadier", 657), evolvesTo: [
                    leaf(species("greninja", 658), details: [levelUp(36)]),
                ], details: [levelUp(16)]),
            ])),
            // ミミッキュ (進化なし)
            403: EvolutionChainResponse(id: 403, chain: leaf(species("mimikyu", 778))),
        ]
    }()
}

// swiftlint:enable file_length type_body_length
