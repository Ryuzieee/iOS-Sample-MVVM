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
    @StateObject private var listViewModel = DependencyContainer.shared.makePokemonListViewModel()
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
                viewModel: listViewModel,
                onPokemonTap: { name in path.append(.detail(name)) },
                onSearchTap: { showSearch = true },
                onFavoritesTap: { showFavorites = true }
            )
            .routeDestination(container: container, path: $path)
        }
        .sheet(isPresented: $showSearch, onDismiss: { searchPath = [] }) {
            NavigationStack(path: $searchPath) {
                SearchView(
                    viewModel: container.makeSearchViewModel(),
                    onPokemonTap: { name in searchPath.append(.detail(name)) }
                )
                .routeDestination(container: container, path: $searchPath)
            }
        }
        .sheet(isPresented: $showFavorites, onDismiss: { favoritesPath = [] }) {
            NavigationStack(path: $favoritesPath) {
                FavoritesView(
                    viewModel: container.makeFavoritesViewModel(),
                    onPokemonTap: { name in favoritesPath.append(.detail(name)) }
                )
                .routeDestination(container: container, path: $favoritesPath)
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

/// ナビゲーションルート定義。新画面を追加する場合は case を追加し、
/// RouteDestination の switch に対応するビューを記述する。
enum Route: Hashable {
    case detail(String)
}

/// Route に対応する遷移先ビューを解決する ViewModifier。
/// NavigationStack ごとに `.routeDestination()` を付けるだけで全ルートが有効になる。
private struct RouteDestination: ViewModifier {
    let container: DependencyContainer
    @Binding var path: [Route]

    func body(content: Content) -> some View {
        content.navigationDestination(for: Route.self) { route in
            switch route {
            case let .detail(name):
                PokemonDetailView(
                    viewModel: container.makePokemonDetailViewModel(name: name),
                    onPokemonTap: { newName in path.append(.detail(newName)) }
                )
            }
        }
    }
}

private extension View {
    func routeDestination(
        container: DependencyContainer,
        path: Binding<[Route]>
    ) -> some View {
        modifier(RouteDestination(container: container, path: path))
    }
}
