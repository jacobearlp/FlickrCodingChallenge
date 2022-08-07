//
//  PhotoListView.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import SwiftUI

struct PhotoListView: View {
    
    @ObservedObject var viewModel: PhotoListViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.outputs.photos.isEmpty {
                    Text(Messaging.EmptyList)
                } else {
                    List(viewModel.outputs.photos) { photo in
                        PhotoListRow(flickrPhoto: photo, favoriteAction: viewModel.inputs.didToggleFavorite(photo:))
                    }
                    .padding(0)
                    .edgesIgnoringSafeArea([.leading, .trailing])
                    .listStyle(PlainListStyle())
                }
            }
            .alert(isPresented: Binding<Bool>.constant(viewModel.outputs.isErrorShown), content: { () -> Alert in
                Alert(title: Text(Errors.ErrorTitle), message: Text(viewModel.outputs.errorMessage))
            })
            .navigationBarTitle(Text(NavigationTitle.Photos))
        }
        .onAppear {
            viewModel.inputs.onAppear()
        }
    }
}
