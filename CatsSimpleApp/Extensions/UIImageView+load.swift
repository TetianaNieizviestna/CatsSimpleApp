//
//  UIImageView+load.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String?) {
        if let path = urlString {
            setImage(with: URL(string: path))
        }
    }
    
    func setImage(with url: URL?) {
        guard let url = url else { return }
        
        let width = self.frame.size.width * UIScreen.main.scale
        let height = self.frame.size.height * UIScreen.main.scale
        let size = CGSize(width: width, height: height)
        
        let processor = DownsamplingImageProcessor(size: size)

        kf.setImage(
            with: url,
            placeholder: Style.Image.placeholderImage,
            options: [
                .processor(processor),
                .fromMemoryCacheOrRefresh,
                .diskCacheExpiration(.seconds(3600)),
                .callbackQueue(.mainAsync)
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { result in
                // Image loaded
            }
        )
    }
}
