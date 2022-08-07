//
//  FlickrLikedPhoto.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

struct FlickrLikedPhoto: Identifiable {
    
    var id: String
    var title: String
    var ownername: String
    var urlM: String
    
}

extension FlickrLikedPhoto: Persistable {
    init(managedObject: FlickrLikedPhotoObject) {
        id = managedObject.id
        title = managedObject.title
        ownername = managedObject.ownername
        urlM = managedObject.urlM
    }

    func managedObject() -> FlickrLikedPhotoObject {
        let photo = FlickrLikedPhotoObject()
        photo.id = id
        photo.title = title
        photo.ownername = ownername
        photo.urlM = urlM
        return photo
    }
}
