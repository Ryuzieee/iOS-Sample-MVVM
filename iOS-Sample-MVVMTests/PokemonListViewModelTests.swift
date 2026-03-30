//
//  PokemonListViewModelTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

@MainActor
final class PokemonListViewModelTests: XCTestCase {
    private var repository: MockPokemonRepository!

    override func setUp() {
        repository = MockPokemonRepository()
    }

    private func createViewModel() -> PokemonListViewModel {
        let useCase = GetPokemonListUseCase(repository: repository)
        return PokemonListViewModel(getPokemonList: useCase)
    }

    func test_初回読み込みでポケモン一覧を取得できる() async {
        repository.getPokemonListResult = .success(TestFixtures.fakePokemonList)

        let viewModel = createViewModel()
        viewModel.loadInitial()

        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(viewModel.items, TestFixtures.fakePokemonList)
        if case .success = viewModel.loadState {
            // OK
        } else {
            XCTFail("Expected success state")
        }
    }

    func test_初回読み込み失敗でエラー状態になる() async {
        repository.getPokemonListResult = .failure(AppError.network("timeout"))

        let viewModel = createViewModel()
        viewModel.loadInitial()

        try? await Task.sleep(for: .milliseconds(100))

        if case .error = viewModel.loadState {
            // OK
        } else {
            XCTFail("Expected error state")
        }
        XCTAssertTrue(viewModel.items.isEmpty)
    }

    func test_refreshでリストがリセットされる() async {
        repository.getPokemonListResult = .success(TestFixtures.fakePokemonList)

        let viewModel = createViewModel()
        viewModel.loadInitial()
        try? await Task.sleep(for: .milliseconds(100))

        viewModel.refresh()
        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(viewModel.items, TestFixtures.fakePokemonList)
        XCTAssertFalse(viewModel.isRefreshing)
    }
}
