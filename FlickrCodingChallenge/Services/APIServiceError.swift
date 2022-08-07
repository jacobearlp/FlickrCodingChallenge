//
//  APIServiceError.swift
//  FlickrCodingChallenge (iOS)
//
//  Created by Jacob on 8/6/22.
//

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
}
