//
//  PokemonNameMapperTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import XCTest
@testable import iOS_Sample_MVVM

final class PokemonNameMapperTests: XCTestCase {
    func test_レスポンスから名前リストを正しく抽出する() {
        let response = PokemonListResponse(results: [
            .init(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            .init(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
        ])

        let names = response.toNames()

        XCTAssertEqual(names, ["bulbasaur", "charmander"])
    }

    func test_クエリで大文字小文字を区別せずフィルタリングする() {
        let names = ["bulbasaur", "charmander", "charmeleon", "pikachu"]

        let result = PokemonListResponse.filter(names: names, query: "char")

        XCTAssertEqual(result, ["charmander", "charmeleon"])
    }

    func test_クエリの前後の空白をトリムしてフィルタリングする() {
        let names = ["pikachu", "raichu"]

        let result = PokemonListResponse.filter(names: names, query: "  pika  ")

        XCTAssertEqual(result, ["pikachu"])
    }

    func test_一致するものがない場合に空リストを返す() {
        let names = ["bulbasaur"]

        let result = PokemonListResponse.filter(names: names, query: "xyz")

        XCTAssertEqual(result, [])
    }
}
