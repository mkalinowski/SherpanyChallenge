//
//  NetworkWorker.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import Foundation

class NetworkWorker {
    enum Error: Swift.Error {
        case invalidURL
    }

    private let host = "jsonplaceholder.typicode.com"
    private enum Path: String {
        case posts = "/posts"
        case users = "/users"
        case albums = "/albums"
        case photos = "/photos"
    }

    func getPosts(completion: @escaping (() throws -> [Post]) -> Void) {
        getEntities(path: .posts, completion: completion)
    }

    func getUsers(completion: @escaping (() throws -> [User]) -> Void) {
        getEntities(path: .users, completion: completion)
    }

    func getAlbums(completion: @escaping (() throws -> [Album]) -> Void) {
        getEntities(path: .albums, completion: completion)
    }

    func getPhotos(completion: @escaping (() throws -> [Photo]) -> Void) {
        getEntities(path: .photos, completion: completion)
    }

    private func getEntities<Entity>(path: Path, completion: @escaping (() throws -> [Entity]) -> Void) {
        let urlComponents = URLComponents().with {
            $0.scheme = "https"
            $0.host = host
            $0.path = path.rawValue
        }

        guard let url = urlComponents.url else {
            completion { throw Error.invalidURL }
            return
        }

        let request = URLRequest(url: url).with {
            $0.httpMethod = "GET"
        }

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion { throw error }
                return
            }

            guard let data = data else {
                completion { [] }
                return
            }

            do {
                let posts = try JSONDecoder().decode([Entity].self, from: data)
                completion { posts }
            } catch {
                completion { throw error }
            }
        }

        task.resume()
    }
}
