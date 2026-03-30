//
//  DependencyContainer.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// アプリ全体の依存関係を管理するDIコンテナ。
final class DependencyContainer {
    static let shared = DependencyContainer()

    // MARK: - Data Layer

    private lazy var apiClient = PokeAPIClient()
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var favoriteCoreDataStore = FavoriteCoreDataStore(coreDataStack: coreDataStack)

    // MARK: - Repositories

    private lazy var pokemonRepository: PokemonRepositoryProtocol = PokemonRepositoryImpl(apiClient: apiClient)
    private lazy var favoriteRepository: FavoriteRepositoryProtocol = FavoriteRepositoryImpl(store: favoriteCoreDataStore)

    // MARK: - UseCases

    private lazy var getPokemonListUseCase = GetPokemonListUseCase(repository: pokemonRepository)
    private lazy var getPokemonDetailUseCase = GetPokemonDetailUseCase(repository: pokemonRepository)
    private lazy var getPokemonSpeciesUseCase = GetPokemonSpeciesUseCase(repository: pokemonRepository)
    private lazy var getEvolutionChainUseCase = GetEvolutionChainUseCase(
        getPokemonSpeciesUseCase: getPokemonSpeciesUseCase,
        repository: pokemonRepository
    )
    private lazy var getAbilityJapaneseNameUseCase = GetAbilityJapaneseNameUseCase(repository: pokemonRepository)
    private lazy var getPokemonFullDetailUseCase = GetPokemonFullDetailUseCase(
        getPokemonDetailUseCase: getPokemonDetailUseCase,
        getPokemonSpeciesUseCase: getPokemonSpeciesUseCase,
        getEvolutionChainUseCase: getEvolutionChainUseCase,
        getAbilityJapaneseNameUseCase: getAbilityJapaneseNameUseCase
    )
    private lazy var searchPokemonUseCase = SearchPokemonUseCase(repository: pokemonRepository)
    private lazy var getFavoritesUseCase = GetFavoritesUseCase(repository: favoriteRepository)
    private lazy var getIsFavoriteUseCase = GetIsFavoriteUseCase(repository: favoriteRepository)
    private lazy var toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: favoriteRepository)

    // MARK: - ViewModels

    func makePokemonListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(getPokemonList: getPokemonListUseCase)
    }

    func makePokemonDetailViewModel(name: String) -> PokemonDetailViewModel {
        PokemonDetailViewModel(
            pokemonName: name,
            getPokemonFullDetail: getPokemonFullDetailUseCase,
            getIsFavorite: getIsFavoriteUseCase,
            toggleFavorite: toggleFavoriteUseCase
        )
    }

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchPokemon: searchPokemonUseCase)
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(getFavorites: getFavoritesUseCase)
    }
}
