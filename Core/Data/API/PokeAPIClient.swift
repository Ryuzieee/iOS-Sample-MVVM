//
//  PokeAPIClient.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// PokeAPI の REST エンドポイントを呼び出すクライアント。
/// ベースURL: https://pokeapi.co/api/v2/
final class PokeAPIClient {
    private let baseURL = "https://pokeapi.co/api/v2/"
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    // MARK: - Endpoints

    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        let url = "\(baseURL)pokemon?limit=\(limit)&offset=\(offset)"
        return try await request(url: url)
    }

    func getPokemonDetail(name: String) async throws -> PokemonDetailResponse {
        let url = "\(baseURL)pokemon/\(name)"
        return try await request(url: url)
    }

    func getPokemonSpecies(name: String) async throws -> PokemonSpeciesResponse {
        let url = "\(baseURL)pokemon-species/\(name)"
        return try await request(url: url)
    }

    func getEvolutionChain(url: String) async throws -> EvolutionChainResponse {
        return try await request(url: url)
    }

    func getAbility(name: String) async throws -> AbilityResponse {
        let url = "\(baseURL)ability/\(name)"
        return try await request(url: url)
    }

    // MARK: - Private

    private func request<T: Decodable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw AppError.unknown("Invalid URL")
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.unknown("Invalid response")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 404 {
                throw AppError.notFound(query: url.absoluteString)
            }
            throw AppError.server(code: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
