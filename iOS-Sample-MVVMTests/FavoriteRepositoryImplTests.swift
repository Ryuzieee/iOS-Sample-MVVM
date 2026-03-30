//
//  FavoriteRepositoryImplTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import XCTest
@testable import iOS_Sample_MVVM

final class FavoriteRepositoryImplTests: XCTestCase {
    private var store: MockFavoriteStore!
    private var repository: FavoriteRepositoryImpl!

    override func setUp() {
        store = MockFavoriteStore()
        repository = FavoriteRepositoryImpl(store: store)
    }

    func test_お気に入り一覧を正しく取得する() async throws {
        store.getAllFavoritesResult = .success([
            FavoriteModel(id: 1, name: "bulbasaur", imageUrl: "url1"),
            FavoriteModel(id: 25, name: "pikachu", imageUrl: "url25"),
        ])

        let result = try await repository.getFavorites()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "bulbasaur")
        XCTAssertEqual(result[1].name, "pikachu")
    }

    func test_お気に入り取得時に例外が発生した場合にunknownエラーになる() async {
        store.getAllFavoritesResult = .failure(NSError(
            domain: "test",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "db error"]
        ))

        do {
            _ = try await repository.getFavorites()
            XCTFail("Expected error")
        } catch {
            guard case AppError.unknown = error else {
                XCTFail("Expected unknown error, got \(error)")
                return
            }
        }
    }

    func test_お気に入りが存在する場合にtrueを返す() async throws {
        store.isFavoriteResult = .success(true)

        let result = try await repository.isFavorite(id: 1)

        XCTAssertTrue(result)
    }

    func test_お気に入りが存在しない場合にfalseを返す() async throws {
        store.isFavoriteResult = .success(false)

        let result = try await repository.isFavorite(id: 1)

        XCTAssertFalse(result)
    }

    func test_お気に入り追加時にstoreのaddFavoriteが呼ばれる() async throws {
        let detail = TestFixtures.fakePokemonDetail

        try await repository.addFavorite(detail: detail)

        XCTAssertTrue(store.addFavoriteCalled)
        XCTAssertEqual(store.lastAddedDetail?.id, 1)
    }

    func test_お気に入り削除時にstoreのremoveFavoriteが呼ばれる() async throws {
        try await repository.removeFavorite(id: 1)

        XCTAssertTrue(store.removeFavoriteCalled)
        XCTAssertEqual(store.lastRemovedId, 1)
    }
}

final class MockFavoriteStore: FavoriteStoreProtocol {
    var getAllFavoritesResult: Result<[FavoriteModel], Error> = .success([])
    var isFavoriteResult: Result<Bool, Error> = .success(false)
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var lastAddedDetail: PokemonDetailModel?
    var lastRemovedId: Int?

    func getAllFavorites() throws -> [FavoriteModel] {
        try getAllFavoritesResult.get()
    }

    func isFavorite(id _: Int) throws -> Bool {
        try isFavoriteResult.get()
    }

    func addFavorite(detail: PokemonDetailModel) throws {
        addFavoriteCalled = true
        lastAddedDetail = detail
    }

    func removeFavorite(id: Int) throws {
        removeFavoriteCalled = true
        lastRemovedId = id
    }
}
