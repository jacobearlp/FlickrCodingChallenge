//
//  FavoritesListView.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import SwiftUI

struct FavoritesListView: View {
    
    @ObservedObject var viewModel: FavoritesListViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.outputs.photos.isEmpty {
                    Text(Messaging.EmptyList)
                } else {
                    List(viewModel.outputs.photos) { photo in
                        let flickPhoto = FlickrPhoto(
                            id: photo.id,
                            title: photo.title,
                            ownername: photo.ownername,
                            urlM: photo.urlM,
                            isfavorite: true
                        )
                        PhotoListRow(flickrPhoto: flickPhoto) { flickPhoto in
                            self.viewModel.inputs.remove(photo: photo)
                        }
                    }
                    .edgesIgnoringSafeArea([.leading, .trailing])
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle(Text(NavigationTitle.Favorites))
        }
        .onAppear {
            viewModel.inputs.onAppear()
        }
    }
}
