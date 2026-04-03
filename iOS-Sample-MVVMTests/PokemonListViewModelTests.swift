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
        return PokemonListViewModel(getPokemonListUseCase: useCase)
    }

    func test_初回読み込みでポケモン一覧を取得できる() async {
        repository.getPokemonListResult = .success(TestFixtures.fakePokemonList)

        let viewModel = createViewModel()
        viewModel.loadInitial()

        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(viewModel.lastItems, TestFixtures.fakePokemonList)
        if case .success = viewModel.content {
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

        if case .error = viewModel.content {
            // OK
        } else {
            XCTFail("Expected error state")
        }
        XCTAssertTrue(viewModel.lastItems.isEmpty)
    }

    func test_refreshでリストが更新される() async {
        repository.getPokemonListResult = .success(TestFixtures.fakePokemonList)

        let viewModel = createViewModel()
        viewModel.loadInitial()
        try? await Task.sleep(for: .milliseconds(100))

        viewModel.refresh()
        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(viewModel.lastItems, TestFixtures.fakePokemonList)
    }

    func test_リフレッシュ失敗時にデータが維持される() async {
        repository.getPokemonListResult = .success(TestFixtures.fakePokemonList)

        let viewModel = createViewModel()
        viewModel.loadInitial()
        try? await Task.sleep(for: .milliseconds(100))

        repository.getPokemonListResult = .failure(AppError.network("timeout"))
        viewModel.refresh()
        try? await Task.sleep(for: .milliseconds(100))

        // content は .error だが lastItems は前回データを維持
        if case .error = viewModel.content {
            // OK
        } else {
            XCTFail("Expected error state")
        }
        XCTAssertEqual(viewModel.lastItems, TestFixtures.fakePokemonList)
    }
}
