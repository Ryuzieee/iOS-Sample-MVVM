//
//  PokemonNameMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

/// ポケモン名リストの変換・検索フィルタリングを行う Mapper。
enum PokemonNameMapper {
    /// レスポンスから名前リストを抽出する。
    static func toNames(from response: PokemonListResponse) -> [String] {
        response.results.map(\.name)
    }

    /// 名前リストをクエリでフィルタリングする（大文字小文字区別なし、前後の空白トリム）。
    static func filter(names: [String], query: String) -> [String] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        return names.filter { $0.localizedCaseInsensitiveContains(trimmed) }
    }
}
