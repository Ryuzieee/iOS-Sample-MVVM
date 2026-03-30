//
//  SearchPokemonUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class SearchPokemonUseCaseTests: XCTestCase {
    private var repository: MockPokemonRepository!
    private var useCase: SearchPokemonUseCase!

    override func setUp() {
        repository = MockPokemonRepository()
        useCase = SearchPokemonUseCase(repository: repository)
    }

    func test_検索成功時に一致する名前リストを返す() async throws {
        repository.searchPokemonNamesResult = .success(["pikachu"])

        let result = try await useCase(query: "pika")

        XCTAssertEqual(result, ["pikachu"])
    }

    func test_検索結果が空の場合にNotFoundエラーを返す() async {
        repository.searchPokemonNamesResult = .success([])

        do {
            _ = try await useCase(query: "xyz")
            XCTFail("Expected error")
        } catch {
            guard case AppError.notFound = error else {
                XCTFail("Expected notFound error, got \(error)")
                return
            }
        }
    }

    func test_リポジトリ失敗時にエラーを返す() async {
        repository.searchPokemonNamesResult = .failure(AppError.network("timeout"))

        do {
            _ = try await useCase(query: "pika")
            XCTFail("Expected error")
        } catch {
            guard case AppError.network = error else {
                XCTFail("Expected network error, got \(error)")
                return
            }
        }
    }
}
