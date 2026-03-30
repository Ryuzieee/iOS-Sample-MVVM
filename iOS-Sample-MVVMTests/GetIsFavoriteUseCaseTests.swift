//
//  GetIsFavoriteUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class GetIsFavoriteUseCaseTests: XCTestCase {
    private var repository: MockFavoriteRepository!
    private var useCase: GetIsFavoriteUseCase!

    override func setUp() {
        repository = MockFavoriteRepository()
        useCase = GetIsFavoriteUseCase(repository: repository)
    }

    func test_お気に入り登録済みの場合にtrueを返す() async throws {
        repository.isFavoriteResult = .success(true)

        let result = try await useCase(id: 1)

        XCTAssertTrue(result)
    }

    func test_お気に入り未登録の場合にfalseを返す() async throws {
        repository.isFavoriteResult = .success(false)

        let result = try await useCase(id: 1)

        XCTAssertFalse(result)
    }
}
