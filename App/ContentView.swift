//
//  ContentView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// アプリのルートナビゲーション。
struct ContentView: View {
    private let container = DependencyContainer.shared
    @State private var path: [Route] = []
    #if MOCK
        @State private var showMockSelector = false
    #endif

    var body: some View {
        NavigationStack(path: $path) {
            PokemonListView(
                viewModel: container.makePokemonListViewModel(),
                onPokemonTap: { name in path.append(.detail(name)) },
                onSearchTap: { path.append(.search) },
                onFavoritesTap: { path.append(.favorites) }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .detail(name):
                    PokemonDetailView(
                        viewModel: container.makePokemonDetailViewModel(name: name),
                        onPokemonTap: { newName in path.append(.detail(newName)) }
                    )
                case .search:
                    SearchView(
                        viewModel: container.makeSearchViewModel(),
                        onPokemonTap: { name in path.append(.detail(name)) }
                    )
                case .favorites:
                    FavoritesView(
                        viewModel: container.makeFavoritesViewModel(),
                        onPokemonTap: { name in path.append(.detail(name)) }
                    )
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
    case search
    case favorites
}
