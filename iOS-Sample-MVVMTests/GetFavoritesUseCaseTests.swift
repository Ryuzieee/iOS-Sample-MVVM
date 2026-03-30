//
//  GetFavoritesUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class GetFavoritesUseCaseTests: XCTestCase {
    private var repository: MockFavoriteRepository!
    private var useCase: GetFavoritesUseCase!

    override func setUp() {
        repository = MockFavoriteRepository()
        useCase = GetFavoritesUseCase(repository: repository)
    }

    func test_お気に入り取得成功時にリストを返す() async throws {
        let favorites = [
            FavoriteModel(id: 1, name: "bulbasaur", imageUrl: "url1"),
            FavoriteModel(id: 25, name: "pikachu", imageUrl: "url25"),
        ]
        repository.getFavoritesResult = .success(favorites)

        let result = try await useCase()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "bulbasaur")
        XCTAssertEqual(result[1].name, "pikachu")
    }

    func test_お気に入りが空の場合は空リストを返す() async throws {
        repository.getFavoritesResult = .success([])

        let result = try await useCase()

        XCTAssertTrue(result.isEmpty)
    }
}
