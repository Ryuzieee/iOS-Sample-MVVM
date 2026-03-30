//
//  GetPokemonSpeciesUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class GetPokemonSpeciesUseCaseTests: XCTestCase {
    private var repository: MockPokemonRepository!
    private var useCase: GetPokemonSpeciesUseCase!

    override func setUp() {
        repository = MockPokemonRepository()
        useCase = GetPokemonSpeciesUseCase(repository: repository)
    }

    func test_種族情報取得成功時にモデルを返す() async throws {
        repository.getPokemonSpeciesResult = .success(TestFixtures.fakeSpecies)

        let result = try await useCase.execute(name: "bulbasaur")

        XCTAssertEqual(result.japaneseName, "フシギダネ")
        XCTAssertEqual(result.genus, "たねポケモン")
    }

    func test_種族情報取得失敗時にエラーを返す() async {
        repository.getPokemonSpeciesResult = .failure(AppError.network("timeout"))

        do {
            _ = try await useCase.execute(name: "bulbasaur")
            XCTFail("Expected error")
        } catch {
            guard case AppError.network = error else {
                XCTFail("Expected network error")
                return
            }
        }
    }
}
