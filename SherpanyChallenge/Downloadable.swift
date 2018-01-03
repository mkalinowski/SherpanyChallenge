//
//  Downloadable.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import Foundation

enum DownloadError: Swift.Error {
    case noData
    case invalidURL
}

protocol Downloadable {
    static var host: String { get }
    static var path: String { get }
}

extension Downloadable {
    static var host: String {
        return "jsonplaceholder.typicode.com"
    }

    static func download(completion: @escaping (() throws -> Data) -> Void) {
        let urlComponents = URLComponents().with {
            $0.scheme = "https"
            $0.host = host
            $0.path = path
        }

        guard let url = urlComponents.url else {
            completion { throw DownloadError.invalidURL }
            return
        }

        let request = URLRequest(url: url).with {
            $0.httpMethod = "GET"
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion { throw error }
                return
            }

            guard let data = data else {
                completion { throw DownloadError.noData }
                return
            }

            completion { data }
        }

        task.resume()
    }
}
