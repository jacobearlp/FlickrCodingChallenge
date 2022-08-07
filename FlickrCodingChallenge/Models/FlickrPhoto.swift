//
//  FlickrPhoto.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/6/22.
//

struct FlickrPhoto: Codable, Identifiable {
    
    var id: String
    var title: String
    var ownername: String
    var urlM: String
    var isfavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, title, ownername, urlM
    }
    
    
    func toLikedFlickrPhoto() -> FlickrLikedPhoto {
        FlickrLikedPhoto(id: id, title: title, ownername: ownername, urlM: urlM)
    }
}


extension FlickrPhoto: Persistable {
    init(managedObject: FlickrPhotoObject) {
        id = managedObject.id
        title = managedObject.title
        ownername = managedObject.ownername
        urlM = managedObject.urlM
    }

    func managedObject() -> FlickrPhotoObject {
        let photo = FlickrPhotoObject()
        photo.id = id
        photo.title = title
        photo.ownername = ownername
        photo.urlM = urlM
        return photo
    }
}
