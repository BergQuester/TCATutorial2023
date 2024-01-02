//
//  AddContactFeature.swift
//  Navigation
//
//  Created by Daniel Bergquist on 12/15/23.
//

import SwiftUI
import ComposableArchitecture

import Models

@Reducer
public struct AddContactFeature {
    @ObservableState
    public struct State: Equatable {
        public var contact: Contact

        public init(contact: Contact) {
            self.contact = contact
        }
    }

    public enum Action: Equatable {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)

        public enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }

    @Dependency(\.dismiss) var dismiss

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await dismiss() }

            case .delegate:
                return .none

            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await dismiss()
                }

            case let .setName(name):
                state.contact.name = name
                return .none
            }
        }
    }
}

public struct AddContactView: View {
    @Bindable var store: StoreOf<AddContactFeature>

    public init(store: StoreOf<AddContactFeature>) {
        self.store = store
    }

    public var body: some View {
        Form(content: {
            TextField("Name", text: $store.contact.name.sending(\.setName))
            Button("Save") {
                store.send(.saveButtonTapped)
            }
        })
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(
            store: Store(
                initialState: AddContactFeature.State(
                    contact: Contact(
                        id: UUID(),
                        name: "Blob"
                    )
                )
            )
            {
                AddContactFeature()
            }
        )
    }
}
