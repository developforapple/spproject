//
//  SPItemBannerImageCell.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import SDWebImage

class SPItemBannerImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var playBtn: UIButton!

    func setImageWithURL(_ url: URL?,
                         progress: SDWebImageDownloaderProgressBlock?,
                         completed: SDExternalCompletionBlock?) {

        let options: SDWebImageOptions = [.retryFailed, .progressiveDownload, .continueInBackground, .allowInvalidSSLCertificates]

        imageView.sd_setImage(with: url,
                              placeholderImage: nil,
                              options: options,
                              progress: progress) { [weak self] (_image, _error, _cacheType, _imageURL) in
                                if let image = _image {
                                    let size = image.size
                                    if size.width < 120 && size.height < 120 {
                                        self?.imageView.contentMode = .center
                                    } else {
                                        self?.imageView.contentMode = .scaleAspectFill
                                    }
                                }
                                completed?(_image, _error, _cacheType, _imageURL)
        }

    }
    
}
