//
//  Constants.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/7/22.
//

import CoreGraphics

enum TabItemTitle {
    static let Photos = "Photos"
    static let Favorites = "Favorites"
}

enum NavigationTitle {
    static let Photos = "Photos"
    static let Favorites = "Favorites"
}

enum Messaging {
    static let EmptyList = "List is empty."
    static let Loading = "Loading..."
}

enum ImageNames {
    static let Photo = "photo.fill"
    static let Liked = "bolt.heart.fill"
    static let NotLiked = "bolt.heart"
}

enum Errors {
    static let NetworkError = "Network Error."
    static let ParseError = "Parse Error."
    static let ErrorTitle = "Error"
}

enum Numbers {
    static let RowMaximumHeight: CGFloat = 200
}

enum Network {
    static let apiURL = "https://www.flickr.com/services/rest"
}
