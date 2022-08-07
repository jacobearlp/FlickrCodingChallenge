//
//  APIService.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/6/22.
//

import Combine
import Foundation
import RealmSwift

protocol APIServiceDelegate {
    
    func getPhotos() -> AnyPublisher<FlickrPhotosResponse, APIServiceError>
    func addPhotoToLikes(photo: FlickrPhoto)
    func removePhotoFromLikes(photo: FlickrPhoto)
    func getLikedPhotos() -> [FlickrLikedPhoto]
}

class APIService: APIServiceDelegate {
    
    let realm = try! Realm()
    
    func getPhotos() -> AnyPublisher<FlickrPhotosResponse, APIServiceError> {
        let url = URL(string: "\(Network.apiURL)?method=flickr.people.getPublicPhotos&api_key=56e779b053994c656ecbef2b4ecc9266&user_id=65789667%40N06&extras=url_m%2Cowner_name&format=json&nojsoncallback=1")!
        
        let request = URLRequest(url: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
            
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, urlResponse in data }
            .mapError { _ in APIServiceError.responseError }
            .decode(type: FlickrPhotosResponse.self, decoder: decoder)
            .mapError(APIServiceError.parseError)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func addPhotoToLikes(photo: FlickrPhoto) {
        do {
            try realm.write {
                realm.add(photo.toLikedFlickrPhoto().managedObject(), update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    func removePhotoFromLikes(photo: FlickrPhoto) {
        do {
            if let cachePhoto = realm.objects(FlickrLikedPhotoObject.self)
                .first(where: { $0.id == photo.id }) {
                try realm.write {
                    realm.delete(cachePhoto)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getLikedPhotos() -> [FlickrLikedPhoto] {
        return Array(realm.objects(FlickrLikedPhotoObject.self))
            .map { FlickrLikedPhoto(managedObject: $0) }
    }
}
