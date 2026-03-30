//
//  ContentView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// アプリのルートナビゲーション。
/// Detail は push（水平スライド）、Search/Favorites は sheet（下からモーダル）で遷移。
struct ContentView: View {
    private let container = DependencyContainer.shared
    @State private var path: [Route] = []
    @State private var showSearch = false
    @State private var showFavorites = false
    @State private var searchPath: [Route] = []
    @State private var favoritesPath: [Route] = []
    #if MOCK
        @State private var showMockSelector = false
    #endif

    var body: some View {
        NavigationStack(path: $path) {
            PokemonListView(
                viewModel: container.makePokemonListViewModel(),
                onPokemonTap: { name in path.append(.detail(name)) },
                onSearchTap: { showSearch = true },
                onFavoritesTap: { showFavorites = true }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .detail(name):
                    PokemonDetailView(
                        viewModel: container.makePokemonDetailViewModel(name: name),
                        onPokemonTap: { newName in path.append(.detail(newName)) }
                    )
                }
            }
        }
        .sheet(isPresented: $showSearch, onDismiss: { searchPath = [] }) {
            NavigationStack(path: $searchPath) {
                SearchView(
                    viewModel: container.makeSearchViewModel(),
                    onPokemonTap: { name in searchPath.append(.detail(name)) }
                )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .detail(name):
                        PokemonDetailView(
                            viewModel: container.makePokemonDetailViewModel(name: name),
                            onPokemonTap: { newName in searchPath.append(.detail(newName)) }
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $showFavorites, onDismiss: { favoritesPath = [] }) {
            NavigationStack(path: $favoritesPath) {
                FavoritesView(
                    viewModel: container.makeFavoritesViewModel(),
                    onPokemonTap: { name in favoritesPath.append(.detail(name)) }
                )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .detail(name):
                        PokemonDetailView(
                            viewModel: container.makePokemonDetailViewModel(name: name),
                            onPokemonTap: { newName in favoritesPath.append(.detail(newName)) }
                        )
                    }
                }
            }
        }
        #if MOCK
        .overlay(alignment: .bottomTrailing) {
                Button(action: { showMockSelector = true }) {
                    Image(systemName: "ladybug")
                        .font(.title2)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(16)
            }
            .sheet(isPresented: $showMockSelector) {
                MockScenarioSelector()
            }
        #endif
    }
}

/// ナビゲーションルート定義。
enum Route: Hashable {
    case detail(String)
}
