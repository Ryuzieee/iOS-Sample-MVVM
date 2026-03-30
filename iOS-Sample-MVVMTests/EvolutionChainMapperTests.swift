//
//  EvolutionChainMapperTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class EvolutionChainMapperTests: XCTestCase {
    func test_進化チェーンを正しくフラット化する() {
        let response = EvolutionChainResponse(
            id: 1,
            chain: EvolutionChainResponse.ChainLink(
                species: EvolutionChainResponse.Species(
                    name: "bulbasaur",
                    url: "https://pokeapi.co/api/v2/pokemon-species/1/"
                ),
                evolvesTo: [
                    EvolutionChainResponse.ChainLink(
                        species: EvolutionChainResponse.Species(
                            name: "ivysaur",
                            url: "https://pokeapi.co/api/v2/pokemon-species/2/"
                        ),
                        evolvesTo: [
                            EvolutionChainResponse.ChainLink(
                                species: EvolutionChainResponse.Species(
                                    name: "venusaur",
                                    url: "https://pokeapi.co/api/v2/pokemon-species/3/"
                                ),
                                evolvesTo: [],
                                evolutionDetails: [EvolutionChainResponse.EvolutionDetail(minLevel: 32, trigger: nil)]
                            ),
                        ],
                        evolutionDetails: [EvolutionChainResponse.EvolutionDetail(minLevel: 16, trigger: nil)]
                    ),
                ],
                evolutionDetails: []
            )
        )

        let stages = EvolutionChainMapper.toModel(from: response)

        XCTAssertEqual(stages.count, 3)
        XCTAssertEqual(stages[0].name, "bulbasaur")
        XCTAssertEqual(stages[0].id, 1)
        XCTAssertNil(stages[0].minLevel)
        XCTAssertEqual(stages[1].name, "ivysaur")
        XCTAssertEqual(stages[1].id, 2)
        XCTAssertEqual(stages[1].minLevel, 16)
        XCTAssertEqual(stages[2].name, "venusaur")
        XCTAssertEqual(stages[2].id, 3)
        XCTAssertEqual(stages[2].minLevel, 32)
    }
}
