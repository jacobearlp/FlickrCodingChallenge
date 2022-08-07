//
//  FavoritesListViewModel.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import Combine
import RealmSwift

protocol FavoritesListViewModelInputs {
    func onAppear()
    func remove(photo: FlickrLikedPhoto)
}

protocol FavoritesListViewModelOutputs {
    var photos: [FlickrLikedPhoto] { get }
}

protocol FavoritesListViewModelTypes {
    var inputs: FavoritesListViewModelInputs { get }
    var outputs: FavoritesListViewModelOutputs { get }
}

class FavoritesListViewModel: ObservableObject, FavoritesListViewModelTypes,
                              FavoritesListViewModelInputs, FavoritesListViewModelOutputs {
    
    var inputs: FavoritesListViewModelInputs { self }
    var outputs: FavoritesListViewModelOutputs { self }
    
    @Published var photos: [FlickrLikedPhoto] = []
    
    private var onAppearSubject = PassthroughSubject<Void, Never>()
    private var removePhotoSubject = PassthroughSubject<FlickrLikedPhoto, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    private let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func onAppear() {
        getLikedPhotos()
    }
    
    func remove(photo: FlickrLikedPhoto) {
        let flickrPhoto = FlickrPhoto(id: photo.id,
                                      title: photo.title,
                                      ownername: photo.ownername,
                                      urlM: photo.urlM)
        apiService.removePhotoFromLikes(photo: flickrPhoto)
        photos = apiService.getLikedPhotos()
    }
    
    private func getLikedPhotos() {
        photos = apiService.getLikedPhotos()
    }
}
