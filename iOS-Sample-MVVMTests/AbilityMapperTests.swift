//
//  AbilityMapperTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class AbilityMapperTests: XCTestCase {
    func test_言語名マップを正しく生成する() {
        let response = AbilityResponse(names: [
            AbilityResponse.Name(name: "Overgrow", language: NamedResource(name: "en")),
            AbilityResponse.Name(name: "しんりょく", language: NamedResource(name: "ja")),
            AbilityResponse.Name(name: "おおもり", language: NamedResource(name: "ja-Hrkt")),
        ])

        let result = response.toLocalizedNames()

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result["en"], "Overgrow")
        XCTAssertEqual(result["ja"], "しんりょく")
    }

    func test_namesが空の場合に空のマップを返す() {
        let response = AbilityResponse(names: [])
        let result = response.toLocalizedNames()
        XCTAssertTrue(result.isEmpty)
    }
}
