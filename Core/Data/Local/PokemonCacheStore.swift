//
//  PokemonCacheStore.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

/// ポケモンデータのローカルキャッシュ。Codable + FileManager ベース。
/// Android の Room (PokemonDetailEntity / PokemonNameEntity) に相当。
final class PokemonCacheStore {
    static let shared = PokemonCacheStore()

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private lazy var cacheDirectory: URL = {
        let dir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("PokemonCache", isDirectory: true)
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    func getPokemonDetail(name: String) -> CachedEntry<PokemonDetailModel>? {
        load(filename: "detail_\(name)")
    }

    func savePokemonDetail(_ detail: PokemonDetailModel, name: String) {
        let entry = CachedEntry(data: detail, cachedAt: Date())
        save(entry, filename: "detail_\(name)")
    }

    func getPokemonNames() -> CachedEntry<[String]>? {
        load(filename: "pokemon_names")
    }

    func savePokemonNames(_ names: [String]) {
        let entry = CachedEntry(data: names, cachedAt: Date())
        save(entry, filename: "pokemon_names")
    }

    private func save(_ entry: CachedEntry<some Codable>, filename: String) {
        let url = cacheDirectory.appendingPathComponent("\(filename).json")
        do {
            let data = try encoder.encode(entry)
            try data.write(to: url, options: .atomic)
        } catch {
            AppLogger.error("Cache save failed: \(error.localizedDescription)")
        }
    }

    private func load<T: Codable>(filename: String) -> CachedEntry<T>? {
        let url = cacheDirectory.appendingPathComponent("\(filename).json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode(CachedEntry<T>.self, from: data)
    }
}

/// タイムスタンプ付きキャッシュエントリ。
struct CachedEntry<T: Codable>: Codable {
    let data: T
    let cachedAt: Date

    var isExpired: Bool {
        CacheConfig.isExpired(cachedAt: cachedAt)
    }
}
