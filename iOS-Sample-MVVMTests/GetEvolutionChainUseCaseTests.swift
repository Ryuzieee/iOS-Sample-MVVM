//
//  GetEvolutionChainUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class GetEvolutionChainUseCaseTests: XCTestCase {
    private var repository: MockPokemonRepository!
    private var speciesUseCase: GetPokemonSpeciesUseCase!
    private var useCase: GetEvolutionChainUseCase!

    override func setUp() {
        repository = MockPokemonRepository()
        speciesUseCase = GetPokemonSpeciesUseCase(repository: repository)
        useCase = GetEvolutionChainUseCase(
            getPokemonSpeciesUseCase: speciesUseCase,
            repository: repository
        )
    }

    func test_進化チェーン取得成功時にステージを返す() async throws {
        repository.getPokemonSpeciesResult = .success(TestFixtures.fakeSpecies)
        repository.getEvolutionChainResult = .success([
            EvolutionStageModel(name: "bulbasaur", japaneseName: "", id: 1, imageUrl: "url1", minLevel: nil),
            EvolutionStageModel(name: "ivysaur", japaneseName: "", id: 2, imageUrl: "url2", minLevel: 16),
        ])

        let result = try await useCase(name: "bulbasaur")

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].japaneseName, "フシギダネ")
        XCTAssertEqual(result[1].japaneseName, "フシギダネ") // 同じモックなので同じ値
    }

    func test_種族情報取得失敗時にエラーを返す() async {
        repository.getPokemonSpeciesResult = .failure(AppError.network("timeout"))

        do {
            _ = try await useCase(name: "bulbasaur")
            XCTFail("Expected error")
        } catch {
            guard case AppError.network = error else {
                XCTFail("Expected network error")
                return
            }
        }
    }

    func test_進化チェーン取得失敗時にエラーを返す() async {
        repository.getPokemonSpeciesResult = .success(TestFixtures.fakeSpecies)
        repository.getEvolutionChainResult = .failure(AppError.network("timeout"))

        do {
            _ = try await useCase(name: "bulbasaur")
            XCTFail("Expected error")
        } catch {
            // エラーが返ればOK
        }
    }
}
