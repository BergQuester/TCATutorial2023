//
//  ContactsDetailFatureTests.swift
//  NavigationTests
//
//  Created by Daniel Bergquist on 12/22/23.
//

import ComposableArchitecture
import XCTest

@testable import Navigation

@MainActor
final class ContactsDetailFatureTests: XCTestCase {
    func testDeleteContact() async {
        let dismissed = LockIsolated(false)
        let store = TestStore(
            initialState: ContactDetailFeature.State(
                contact: Contact(id: UUID(0), name: "Blob")
            )
        ) {
            ContactDetailFeature()
        } withDependencies: {
            $0.dismiss = DismissEffect { dismissed.setValue(true) }
        }

        await store.send(.deleteButtonTapped) {
            $0.alert = .confirmDeletion
        }

        await store.send(.alert(.presented(.confirmDeletion))) {
            $0.alert = nil
        }
        await store.receive(.delegate(.confirmDeletion))
        XCTAssertTrue(dismissed.value)
    }
}
