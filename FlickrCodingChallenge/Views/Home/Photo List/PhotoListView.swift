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

struct PhotoListRow: View {
    
    var flickrPhoto: FlickrPhoto
    var favoriteAction: ((FlickrPhoto) -> Void)
    
    var body: some View {
        ZStack {
            CacheAsyncImage(url: URL(string: flickrPhoto.urlM)!) { phase in
                switch phase {
                case .success(let image):
                    let _ = print("success")
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: CGFloat.infinity, maxHeight: Numbers.RowMaximumHeight, alignment: .top)
                        .clipped()
                default:
                    let _ = print("failed")
                    Text(Messaging.Loading)
                        .frame(width: CGFloat.greatestFiniteMagnitude, height: Numbers.RowMaximumHeight, alignment: .center)
                }
            }

            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()
                    
                    let imageName = flickrPhoto.isfavorite ? ImageNames.Liked : ImageNames.NotLiked
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.white)
                        .onTapGesture { favoriteAction(flickrPhoto) }
                        .padding([.top, .trailing], 5)
                }
                .padding(0)

                Spacer()
                
                VStack {
                    HStack {
                        Text(flickrPhoto.title)
                            .frame(alignment: .leading)
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    .padding(0)
                    
                    HStack {
                        Text(flickrPhoto.ownername)
                            .frame(alignment: .leading)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    .padding(0)
                }
                .background {
                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.2), .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                }
            }
            .padding(0)
        }
    }
}
