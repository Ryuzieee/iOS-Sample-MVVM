//
//  GetPokemonFullDetailUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class GetPokemonFullDetailUseCaseTests: XCTestCase {
    private var repository: MockPokemonRepository!
    private var useCase: GetPokemonFullDetailUseCase!

    override func setUp() {
        repository = MockPokemonRepository()

        let detailUseCase = GetPokemonDetailUseCase(repository: repository)
        let speciesUseCase = GetPokemonSpeciesUseCase(repository: repository)
        let evolutionUseCase = GetEvolutionChainUseCase(
            getPokemonSpeciesUseCase: speciesUseCase,
            repository: repository
        )
        let abilityUseCase = GetAbilityJapaneseNameUseCase(repository: repository)

        useCase = GetPokemonFullDetailUseCase(
            getPokemonDetailUseCase: detailUseCase,
            getPokemonSpeciesUseCase: speciesUseCase,
            getEvolutionChainUseCase: evolutionUseCase,
            getAbilityJapaneseNameUseCase: abilityUseCase
        )
    }

    func test_全詳細取得成功時に結果を返す() async throws {
        repository.getPokemonDetailResult = .success(TestFixtures.fakePokemonDetail)
        repository.getPokemonSpeciesResult = .success(TestFixtures.fakeSpecies)
        repository.getEvolutionChainResult = .success([])
        repository.getAbilityLocalizedNamesResult = .success(["ja": "しんりょく"])

        let result = try await useCase(name: "bulbasaur")

        XCTAssertEqual(result.detail.name, "bulbasaur")
        XCTAssertNotNil(result.species)
        XCTAssertEqual(result.species?.japaneseName, "フシギダネ")
    }

    func test_詳細取得失敗時にエラーを返す() async {
        repository.getPokemonDetailResult = .failure(AppError.network("timeout"))

        do {
            _ = try await useCase(name: "unknown")
            XCTFail("Expected error")
        } catch {
            guard case AppError.network = error else {
                XCTFail("Expected network error")
                return
            }
        }
    }

    func test_種族情報取得失敗時にspeciesがnilで成功する() async throws {
        repository.getPokemonDetailResult = .success(TestFixtures.fakePokemonDetail)
        repository.getPokemonSpeciesResult = .failure(AppError.network("timeout"))
        repository.getEvolutionChainResult = .failure(AppError.network("timeout"))
        repository.getAbilityLocalizedNamesResult = .success(["ja": "しんりょく"])

        let result = try await useCase(name: "bulbasaur")

        XCTAssertNil(result.species)
        XCTAssertTrue(result.evolutionChain.isEmpty)
    }
}
