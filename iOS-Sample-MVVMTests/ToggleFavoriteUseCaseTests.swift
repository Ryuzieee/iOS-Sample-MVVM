//
//  ToggleFavoriteUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class ToggleFavoriteUseCaseTests: XCTestCase {
    private var repository: MockFavoriteRepository!
    private var useCase: ToggleFavoriteUseCase!

    override func setUp() {
        repository = MockFavoriteRepository()
        useCase = ToggleFavoriteUseCase(repository: repository)
    }

    func test_お気に入り登録済みの場合に削除する() async throws {
        try await useCase(detail: TestFixtures.fakePokemonDetail, isFavorite: true)

        XCTAssertTrue(repository.removeFavoriteCalled)
        XCTAssertEqual(repository.lastRemovedId, 1)
        XCTAssertFalse(repository.addFavoriteCalled)
    }

    func test_お気に入り未登録の場合に追加する() async throws {
        try await useCase(detail: TestFixtures.fakePokemonDetail, isFavorite: false)

        XCTAssertTrue(repository.addFavoriteCalled)
        XCTAssertFalse(repository.removeFavoriteCalled)
    }
}
