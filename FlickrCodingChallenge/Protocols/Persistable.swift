//
//  Persistable.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
