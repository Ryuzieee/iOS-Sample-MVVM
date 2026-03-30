//
//  GetAbilityJapaneseNameUseCaseTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class GetAbilityJapaneseNameUseCaseTests: XCTestCase {
    private var repository: MockPokemonRepository!
    private var useCase: GetAbilityJapaneseNameUseCase!

    override func setUp() {
        repository = MockPokemonRepository()
        useCase = GetAbilityJapaneseNameUseCase(repository: repository)
    }

    func test_日本語名が存在する場合にjaを返す() async throws {
        repository.getAbilityLocalizedNamesResult = .success(["en": "Overgrow", "ja": "しんりょく"])

        let result = try await useCase(name: "overgrow")

        XCTAssertEqual(result, "しんりょく")
    }

    func test_jaがなくjaHrktがある場合にフォールバックする() async throws {
        repository.getAbilityLocalizedNamesResult = .success(["en": "Overgrow", "ja-Hrkt": "しんりょく"])

        let result = try await useCase(name: "overgrow")

        XCTAssertEqual(result, "しんりょく")
    }

    func test_日本語名がない場合に元の名前を返す() async throws {
        repository.getAbilityLocalizedNamesResult = .success(["en": "Overgrow"])

        let result = try await useCase(name: "overgrow")

        XCTAssertEqual(result, "overgrow")
    }
}
