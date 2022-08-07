//
//  FlickrPhotosResponse.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/6/22.
//

struct FlickrPhotosResponse: Decodable {

    var photos: PhotosResponse
    
    struct PhotosResponse: Decodable {
        var page: Int
        var pages: Int
        var perpage: Int
        var total: Int
        var photo: [FlickrPhoto]
        
        enum CodingKeys: String, CodingKey {
            case page, pages, perpage, total, photo
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
}
