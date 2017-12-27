//
//  RemoteImageView.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class RemoteImageView: UIImageView {
    static let imageCache = NSCache<NSString, UIImage>()
    private var downloadTask: URLSessionDataTask?

    func download(_ url: URL) {
        if let image = RemoteImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = image
            return
        }

        if downloadTask?.state == .running {
            return
        }

        downloadTask?.cancel()
        downloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                let image = UIImage(data: data)
                else { return }

            DispatchQueue.main.async {
                self?.image = image
                self?.downloadTask = nil
            }
            RemoteImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
        }

        downloadTask?.resume()
    }

    func cancel() {
        downloadTask?.cancel()
    }
}
