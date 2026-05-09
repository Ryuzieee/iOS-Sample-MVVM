//
//  PokemonCacheStore.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

/// ポケモンキャッシュストアのプロトコル。テスト時にモック差し替え可能。
protocol PokemonCacheStoreProtocol: Sendable {
    func getPokemonDetail(name: String) async -> CachedEntry<PokemonDetailModel>?
    func savePokemonDetail(_ detail: PokemonDetailModel, name: String) async
    func getPokemonNames() async -> CachedEntry<[String]>?
    func savePokemonNames(_ names: [String]) async
}

/// ポケモンデータのローカルキャッシュ。Codable + FileManager ベース。
/// Android の Room (PokemonDetailEntity / PokemonNameEntity) に相当。
/// actor でスレッド安全性を保証する。
actor PokemonCacheStore: PokemonCacheStoreProtocol {
    static let shared = PokemonCacheStore()

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let cacheDirectory: URL

    init(subdirectory: String = "PokemonCache") {
        let fm = FileManager.default
        let dir = fm.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(subdirectory, isDirectory: true)
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        cacheDirectory = dir
    }

    func getPokemonDetail(name: String) -> CachedEntry<PokemonDetailModel>? {
        load(filename: "detail_\(name)")
    }

    func savePokemonDetail(_ detail: PokemonDetailModel, name: String) {
        let entry = CachedEntry(data: detail, cachedAt: Date())
        writeToFile(entry, filename: "detail_\(name)")
    }

    func getPokemonNames() -> CachedEntry<[String]>? {
        load(filename: "pokemon_names")
    }

    func savePokemonNames(_ names: [String]) {
        let entry = CachedEntry(data: names, cachedAt: Date())
        writeToFile(entry, filename: "pokemon_names")
    }

    private func writeToFile(_ entry: CachedEntry<some Codable>, filename: String) {
        let url = cacheDirectory.appendingPathComponent("\(filename).json")
        do {
            let data = try encoder.encode(entry)
            try data.write(to: url, options: .atomic)
        } catch {
            AppLogger.error("Cache save failed: \(error.localizedDescription)", category: AppLogger.data)
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
