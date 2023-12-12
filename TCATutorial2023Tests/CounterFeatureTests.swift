//
//  CounterFeatureTests.swift
//  CounterFeatureTests
//
//  Created by Daniel Bergquist on 12/7/23.
//

import ComposableArchitecture
import XCTest

@testable import TCATutorial2023

@MainActor
final class CounterFeatureTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
