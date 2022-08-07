//
//  PhotoListViewModel.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import Combine
import RealmSwift

protocol PhotoListViewModelInputs {
    func onAppear()
    func didToggleFavorite(photo: FlickrPhoto)
}

protocol PhotoListViewModelOutputs {
    var photos: [FlickrPhoto] { get }
    var isErrorShown: Bool { get set }
    var errorMessage: String { get }
}

protocol PhotoListViewModelTypes {
    var inputs: PhotoListViewModelInputs { get }
    var outputs: PhotoListViewModelOutputs { get }
}

final class PhotoListViewModel: ObservableObject, PhotoListViewModelOutputs, PhotoListViewModelInputs,
 PhotoListViewModelTypes {
    
    var inputs: PhotoListViewModelInputs { return self }
    var outputs: PhotoListViewModelOutputs { return self }
    
    @Published var photos: [FlickrPhoto] = []
    @Published var errorMessage: String = ""
    @Published var isErrorShown: Bool = false
    
    private var cancellables: [AnyCancellable] = []
    
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private let responseSubject = PassthroughSubject<FlickrPhotosResponse, Never>()
    
    private let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
        bindInputs()
        bindOutputs()
    }
    
    public func onAppear() {
        displayLatestPhoto()
        onAppearSubject.send(())
    }
    
    func didToggleFavorite(photo: FlickrPhoto) {
        updatePhoto(photo)
    }
    
    private func bindInputs() {
        let responsePublisher = onAppearSubject.flatMap { [apiService] _ in
            apiService.getPhotos().catch { [weak self] error -> Empty<FlickrPhotosResponse, Never> in
                self?.errorSubject.send(error)
                return .init()
            }
        }
        
        let responseStream = responsePublisher
            .share()
            .subscribe(responseSubject)
        
        cancellables += [
            responseStream
        ]
    }
    
    private func bindOutputs() {
        let photosStream = responseSubject
            .sink { response in
                let likedPhotoIds = self.fetchLikedPhotoIds()
                var newPhotos = [FlickrPhoto]()
                for photo in response.photos.photo {
                    guard let _ = self.photos.firstIndex(where: { $0.id == photo.id }) else {
                        if !newPhotos.contains(where: { $0.id == photo.id }) {
                            var updatedPhoto = photo
                            updatedPhoto.isfavorite = likedPhotoIds.contains(photo.id)
                            newPhotos.append(updatedPhoto)
                        }
                        continue
                    }
                }
                self.savePhotosToRealm(photos: newPhotos)
                self.photos += newPhotos
            }
        
        let errorMessageStream = errorSubject
            .map { error -> String in
                
                let likedPhotoIds = self.fetchLikedPhotoIds()
                var newPhotos: [FlickrPhoto] = []
                for photo in self.fetchLocalPhotos() {
                    var newPhoto = photo
                    if likedPhotoIds.contains(where: { $0 == photo.id }) {
                        newPhoto.isfavorite = true
                    }
                    newPhotos.append(newPhoto)
                }
                self.photos = newPhotos
                
                switch error {
                case .responseError: return Errors.NetworkError
                case .parseError: return Errors.ParseError
                }
            }
            .assign(to: \.errorMessage, on: self)
        
        let errorStream = errorSubject
            .map { _ in true }
            .assign(to: \.isErrorShown, on: self)
        
        cancellables += [
            photosStream,
            errorMessageStream,
            errorStream
        ]
    }
    
    private func updatePhoto(_ photo: FlickrPhoto) {
        let likedPhotos = fetchLikedPhotoIds()
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            // If already in the list, then remove
            if let _ = likedPhotos.firstIndex(where: { $0 == photo.id }) {
                self.photos[index].isfavorite = false
                self.apiService.removePhotoFromLikes(photo: photo)
            } else {
                self.photos[index].isfavorite =  true
                self.apiService.addPhotoToLikes(photo: photo)
            }
        }
    }
    
    private func savePhotosToRealm(photos: [FlickrPhoto]) {
        let realm = apiService.realm
        do {
            try realm.write {
                realm.add(photos.map { $0.managedObject() }, update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    private func fetchLocalPhotos() -> [FlickrPhoto] {
        let realm = apiService.realm
        return Array(realm.objects(FlickrPhotoObject.self))
            .map { FlickrPhoto(managedObject: $0) }
    }
    
    private func fetchLikedPhotoIds() -> [String] {
        apiService.getLikedPhotos().map { $0.id }
    }
    
    private func displayLatestPhoto() {
        let likedPhotoIds = fetchLikedPhotoIds()
        var newPhotos = [FlickrPhoto]()
        for photo in photos {
            if !newPhotos.contains(where: { $0.id == photo.id }) {
                var updatedPhoto = photo
                updatedPhoto.isfavorite = likedPhotoIds.contains(photo.id)
                newPhotos.append(updatedPhoto)
            }
        }
        
        photos = newPhotos
    }
}
