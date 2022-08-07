//
//  FlickrPhotoObject.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import Foundation
import RealmSwift

class FlickrPhotoObject: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var ownername: String = ""
    @objc dynamic var urlM: String = ""
    
    override static func primaryKey() -> String? {
        "id"
    }
}
