//
//  HomeView.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    let apiService: APIService = APIService()
    let realm: Realm = try! Realm()

    var body: some View {
        
        TabView {
            PhotoListView(viewModel: PhotoListViewModel(apiService: apiService))
                .tabItem {
                    VStack {
                        Image(systemName: ImageNames.Photo)
                        Text(TabItemTitle.Photos)
                    }
                }

            FavoritesListView(viewModel: FavoritesListViewModel(apiService: apiService))
                .tabItem {
                    VStack {
                        Image(systemName: ImageNames.Liked)
                        Text(TabItemTitle.Favorites)
                    }
                }
        }
    }
}
