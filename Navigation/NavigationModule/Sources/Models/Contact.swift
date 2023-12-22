//
//  Contact.swift
//
//
//  Created by Daniel Bergquist on 12/22/23.
//

import Foundation

public struct Contact: Equatable, Identifiable {
    public let id: UUID
    public var name: String

    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
