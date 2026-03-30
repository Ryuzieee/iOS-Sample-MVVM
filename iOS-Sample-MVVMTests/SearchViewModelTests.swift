//
//  SearchViewModelTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

@MainActor
final class SearchViewModelTests: XCTestCase {
    private var repository: MockPokemonRepository!

    override func setUp() {
        repository = MockPokemonRepository()
    }

    private func createViewModel() -> SearchViewModel {
        let useCase = SearchPokemonUseCase(repository: repository)
        return SearchViewModel(searchPokemon: useCase)
    }

    func test_初期状態はクエリが空でIdle状態になる() async {
        let viewModel = createViewModel()

        XCTAssertEqual(viewModel.query, "")
        if case .idle = viewModel.content {
            // OK
        } else {
            XCTFail("Expected idle state")
        }

        try? await Task.sleep(nanoseconds: 100_000_000)
        _ = viewModel
    }

    func test_クエリ変更時にクエリが更新される() async {
        let viewModel = createViewModel()

        viewModel.query = "pika"

        XCTAssertEqual(viewModel.query, "pika")

        // Combineのdebounce解放を待つ
        try? await Task.sleep(nanoseconds: 100_000_000)
        _ = viewModel
    }

    func test_retrySearchで再検索できる() async {
        repository.searchPokemonNamesResult = .success(["pikachu"])

        let viewModel = createViewModel()
        viewModel.query = "pika"
        viewModel.retrySearch()

        try? await Task.sleep(nanoseconds: 200_000_000)

        if case let .success(names) = viewModel.content {
            XCTAssertEqual(names, ["pikachu"])
        } else {
            XCTFail("Expected success state")
        }
    }

    func test_空クエリでretrySearchは何もしない() async {
        let viewModel = createViewModel()
        viewModel.retrySearch()

        if case .idle = viewModel.content {
            // OK
        } else {
            XCTFail("Expected idle state")
        }

        try? await Task.sleep(nanoseconds: 100_000_000)
        _ = viewModel
    }
}
