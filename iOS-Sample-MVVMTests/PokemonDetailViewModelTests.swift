//
//  PokemonDetailViewModelTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

@MainActor
final class PokemonDetailViewModelTests: XCTestCase {
    private var pokemonRepository: MockPokemonRepository!
    private var favoriteRepository: MockFavoriteRepository!

    override func setUp() {
        pokemonRepository = MockPokemonRepository()
        favoriteRepository = MockFavoriteRepository()
    }

    private func createViewModel(name: String = "bulbasaur") -> PokemonDetailViewModel {
        let detailUseCase = GetPokemonDetailUseCase(repository: pokemonRepository)
        let speciesUseCase = GetPokemonSpeciesUseCase(repository: pokemonRepository)
        let evolutionUseCase = GetEvolutionChainUseCase(
            getPokemonSpeciesUseCase: speciesUseCase,
            repository: pokemonRepository
        )
        let abilityUseCase = GetAbilityJapaneseNameUseCase(repository: pokemonRepository)
        let fullDetailUseCase = GetPokemonFullDetailUseCase(
            getPokemonDetailUseCase: detailUseCase,
            getPokemonSpeciesUseCase: speciesUseCase,
            getEvolutionChainUseCase: evolutionUseCase,
            getAbilityJapaneseNameUseCase: abilityUseCase
        )
        let isFavoriteUseCase = GetIsFavoriteUseCase(repository: favoriteRepository)
        let toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: favoriteRepository)

        return PokemonDetailViewModel(
            pokemonName: name,
            getPokemonFullDetail: fullDetailUseCase,
            getIsFavorite: isFavoriteUseCase,
            toggleFavorite: toggleFavoriteUseCase
        )
    }

    func test_データ取得成功時はSuccess状態になる() async {
        pokemonRepository.getPokemonDetailResult = .success(TestFixtures.fakePokemonDetail)
        pokemonRepository.getPokemonSpeciesResult = .success(TestFixtures.fakeSpecies)
        pokemonRepository.getEvolutionChainResult = .success([])
        pokemonRepository.getAbilityLocalizedNamesResult = .success(["ja": "しんりょく"])

        let viewModel = createViewModel()
        try? await Task.sleep(nanoseconds: 200_000_000)

        if case .success(let data) = viewModel.content {
            XCTAssertEqual(data.detail.name, "bulbasaur")
            XCTAssertEqual(data.detail.id, 1)
        } else {
            XCTFail("Expected success state, got \(viewModel.content)")
        }
    }

    func test_データ取得失敗時はError状態になる() async {
        pokemonRepository.getPokemonDetailResult = .failure(AppError.network("timeout"))

        let viewModel = createViewModel()
        try? await Task.sleep(nanoseconds: 200_000_000)

        if case .error = viewModel.content {
            // OK
        } else {
            XCTFail("Expected error state")
        }
    }

    func test_toggleFavoriteでお気に入り状態が反転する() async {
        pokemonRepository.getPokemonDetailResult = .success(TestFixtures.fakePokemonDetail)
        pokemonRepository.getPokemonSpeciesResult = .success(TestFixtures.fakeSpecies)
        pokemonRepository.getEvolutionChainResult = .success([])
        pokemonRepository.getAbilityLocalizedNamesResult = .success([:])

        let viewModel = createViewModel()
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertFalse(viewModel.isFavorite)

        viewModel.toggleFavorite()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(viewModel.isFavorite)
    }
}
