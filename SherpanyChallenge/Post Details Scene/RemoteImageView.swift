//
//  RemoteImageView.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

final class RemoteImageView: UIImageView {
    static let imageCache = NSCache<NSString, UIImage>()
    private var downloadTask: URLSessionDataTask?

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    static let session = URLSession(configuration: URLSessionConfiguration.default.with {
        $0.timeoutIntervalForResource = 60
        $0.waitsForConnectivity = true
    })

    override var image: UIImage? {
        didSet {
            activityIndicator.stopAnimating()
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        addSubview(activityIndicator)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = center
    }

    func download(_ url: URL) {
        downloadTask?.cancel()
        if let image = RemoteImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = image
            return
        }

        if downloadTask?.state == .running {
            return
        }

        NetworkActivityIndicator.show()
        activityIndicator.startAnimating()
        downloadTask = RemoteImageView.session.dataTask(with: url) { [weak self] data, response, error in
            NetworkActivityIndicator.hide()
            guard let data = data,
                let image = UIImage(data: data)
                else { return }

            if let error = error {
                log(error.localizedDescription, type: .fault)
            }

            assert(self?.downloadTask?.state != .canceling)
            DispatchQueue.main.async {
                assert(response?.url == url)
                self?.image = image
                self?.downloadTask = nil
                RemoteImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            }
        }

        downloadTask?.resume()
    }

    func cancel() {
        image = nil
        downloadTask?.cancel()
        activityIndicator.stopAnimating()
    }
}
