//
//  ContactsFeature.swift
//  Navigation
//
//  Created by Daniel Bergquist on 12/14/23.
//

import SwiftUI
import ComposableArchitecture

import Models
import AddContactFeature
import ContactDetailFeature

@Reducer
public struct ContactsFeature {
    public struct State: Equatable {
        var contacts: IdentifiedArrayOf<Contact> = []
        @PresentationState var destination: Destination.State?
        var path = StackState<ContactDetailFeature.State>()

        public init(contacts: IdentifiedArrayOf<Contact> = [], destination: Destination.State? = nil, path: StackState<ContactDetailFeature.State> = StackState<ContactDetailFeature.State>()) {
            self.contacts = contacts
            self.destination = destination
            self.path = path
        }
    }

    public enum Action: Equatable {
        case addButtonTapped
        case deleteButtonTapped(id: Contact.ID)
        case destination(PresentationAction<Destination.Action>)
        case path(StackAction<ContactDetailFeature.State, ContactDetailFeature.Action>)
        public enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }

    @Dependency(\.uuid) var uuid

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: uuid(), name: "")
                    )
                )
                return .none

            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none

            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none

            case .destination:
                return .none

            case let .deleteButtonTapped(id: id):
                state.destination = .alert(.deleteConfirmation(id: id))
                return .none

            case let .path(.element(id: id, action: .delegate(.confirmDeletion))):
                guard let detailState = state.path[id: id]
                else { return .none }
                state.contacts.remove(id: detailState.contact.id)
                return .none

            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
        .forEach(\.path, action: \.path) {
            ContactDetailFeature()
        }
    }
}

extension ContactsFeature {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case addContact(AddContactFeature.State)
            case alert(AlertState<ContactsFeature.Action.Alert>)
        }

        public enum Action: Equatable {
            case addContact(AddContactFeature.Action)
            case alert(ContactsFeature.Action.Alert)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.addContact, action: \.addContact) {
                AddContactFeature()
            }
        }
    }
}

extension AlertState where Action == ContactsFeature.Action.Alert {
    static func deleteConfirmation(id: UUID) -> Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                TextState("Delete")
            }
        }
    }
}

public struct ContactsView: View {
    let store: StoreOf<ContactsFeature>

    public init(store: StoreOf<ContactsFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            WithViewStore(store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        NavigationLink(state: ContactDetailFeature.State(contact: contact)) {
                            HStack {
                                Text(contact.name)
                                Spacer()
                                Button {
                                    viewStore.send(.deleteButtonTapped(id: contact.id))
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .buttonStyle(.borderless)
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
        } destination: { store in
            ContactDetailView(store: store)
        }
        .sheet(
            store: store.scope(
                state: \.$destination.addContact,
                action: \.destination.addContact
            )
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
       .alert(
            store: store.scope(
                state: \.$destination.alert,
                action: \.destination.alert
            )
        )
    }
}

#Preview {
    ContactsView(store:
                    Store(initialState: ContactsFeature.State(
                        contacts: [
                            Contact(id: UUID(), name: "Blob"),
                            Contact(id: UUID(), name: "Blob Jr"),
                            Contact(id: UUID(), name: "Blob Sr"),
                        ]
                    )) {
                        ContactsFeature()
                    }
                )
}
