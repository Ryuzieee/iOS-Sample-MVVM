//
//  FavoritesViewModelTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    private var repository: MockFavoriteRepository!

    override func setUp() {
        repository = MockFavoriteRepository()
    }

    private func createViewModel() -> FavoritesViewModel {
        let useCase = GetFavoritesUseCase(repository: repository)
        return FavoritesViewModel(getFavorites: useCase)
    }

    func test_お気に入り取得成功時にSuccess状態になる() async {
        let favorites = [
            FavoriteModel(id: 1, name: "bulbasaur", imageUrl: "url1"),
            FavoriteModel(id: 25, name: "pikachu", imageUrl: "url25"),
        ]
        repository.getFavoritesResult = .success(favorites)

        let viewModel = createViewModel()
        try? await Task.sleep(for: .milliseconds(100))

        if case let .success(data) = viewModel.content {
            XCTAssertEqual(data.count, 2)
        } else {
            XCTFail("Expected success state")
        }
    }

    func test_お気に入り取得失敗時にError状態になる() async {
        repository.getFavoritesResult = .failure(AppError.unknown("db error"))

        let viewModel = createViewModel()
        try? await Task.sleep(for: .milliseconds(100))

        if case .error = viewModel.content {
            // OK
        } else {
            XCTFail("Expected error state")
        }
    }

    func test_お気に入りが空の場合は空リストでSuccess状態になる() async {
        repository.getFavoritesResult = .success([])

        let viewModel = createViewModel()
        try? await Task.sleep(for: .milliseconds(100))

        if case let .success(data) = viewModel.content {
            XCTAssertEqual(data.count, 0)
        } else {
            XCTFail("Expected success state")
        }
    }
}
