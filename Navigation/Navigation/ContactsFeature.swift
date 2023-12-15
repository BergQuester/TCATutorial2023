//
//  ContactsFeature.swift
//  Navigation
//
//  Created by Daniel Bergquist on 12/14/23.
//

import SwiftUI
import ComposableArchitecture

struct Contacts: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    struct State: Equatable {
        var contacts: IdentifiedArrayOf<Contacts> = []
    }
    enum Action {
        case addButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:

                return .none
            }
        }
    }
}

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>

    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        Text(contact.name)
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContactsView(store:
                    Store(initialState: ContactsFeature.State(
                        contacts: [
                            Contacts(id: UUID(), name: "Blob"),
                            Contacts(id: UUID(), name: "Blob Jr"),
                            Contacts(id: UUID(), name: "Blob Sr"),
                        ]
                    )) {
                        ContactsFeature()
                    }
                )
}
