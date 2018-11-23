//
//  SPItemBannerView.swift
//  D2SP
//
//  Created by bo wang on 2018/11/23.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import ReactiveObjC
import IDMPhotoBrowser

enum SPItemBannerInfoType: Int {
    case progress   //进度
    case playable   //可播放类型
    case size       //大小
    case index      //索引
}

enum SPItemBannerPlayable: Int {
    case none   //不可播放
    case gif    //GIF图
    case video  //视频
    case audio  //音频
}

class SPItemBannerImageInfo: NSObject {
    var index: Int = 0          //索引
    var imageCount: Int = 0     //图片数量
    var url: URL                //资源URL
    var playable: SPItemBannerPlayable  //可播放资源类型
    var received: Int?          //接收字节数
    var length: Int?            //总字节数
    var error: NSError?         //错误信息
    var completed = false       //已完成

    var progress: Float? {
        guard let re = received, let len = length else { return nil }
        return Float(re) / Float(len)
    }

    var lengthDesc: String {
        guard let len = length else { return "" }
        let kb = 1024
        let mb = kb * kb
        switch len {
        case 0..<kb:
            return "\(len)Byte"
        case kb..<mb:
            return String.init(format: "%.1fKB", Float(len) / Float(kb))
        case mb...:
            return String.init(format: "%.1fMB", Float(len) / Float(mb))
        default:
            return ""
        }
    }

    var isPlayable: Bool {
        return playable != .none
    }

    init(url: URL) {
        self.url = url
        self.playable = url.pathExtension.caseInsensitiveCompare("gif") == .orderedSame ? .gif : .none
    }
}

class SPItemBannerInfoUnit: UIView {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!

    var type: SPItemBannerInfoType!
    func update(_ info: SPItemBannerImageInfo) {
        switch type! {
        case .index:
            infoLabel.text = "\(info.index+1)/\(info.imageCount)"
        case .progress:
            infoLabel.text = "\(Int((info.progress ?? 0) * 100))%"
        case .playable: 
            switch info.playable {
            case .none: break
            case .gif:
                infoLabel.text = "GIF"
            case .video:
                infoLabel.text = "Video"
            case .audio:
                infoLabel.text = "Audio"
            }
        case .size:
            infoLabel.text = info.lengthDesc
        }
    }

    override var isHidden: Bool {
        didSet {
            horizontalZero_ = isHidden
            isCollapsed = isHidden
        }
    }
}

class SPItemBannerInfoView: UIView {
    @IBOutlet weak var progressUnit: SPItemBannerInfoUnit!
    @IBOutlet weak var playableUnit: SPItemBannerInfoUnit!
    @IBOutlet weak var sizeUnit: SPItemBannerInfoUnit!
    @IBOutlet weak var indexUnit: SPItemBannerInfoUnit!

    var shouldShow = false {
        didSet {
            setHidden(!shouldShow, animated: true)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        indexUnit.type = .index
        sizeUnit.type = .size
        playableUnit.type = .playable
        progressUnit.type = .progress
    }

    func update(_ info: SPItemBannerImageInfo) {
        guard shouldShow else { return }

        // index
        indexUnit.update(info)
        indexUnit.isHidden = false

        // size
        if let len = info.length {
            sizeUnit.update(info)
            sizeUnit.isHidden = false
        } else {
            sizeUnit.isHidden = true
        }

        // playable
        if info.isPlayable {
            playableUnit.update(info)
            playableUnit.isHidden = false
        } else {
            playableUnit.isHidden = true
        }

        // progress
        if !info.completed, let re = info.received, let len = info.length {
            progressUnit.update(info)
            progressUnit.isHidden = false
        } else {
            progressUnit.isHidden = true
        }

        layoutIfNeeded()
    }
}

class SPItemBannerView: UIView {

    @IBOutlet weak var infoView: SPItemBannerInfoView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!

    var itemData: SPItemSharedData? {
        didSet {
            update()
        }
    }

    private var imageInfoList: [SPItemBannerImageInfo] = []
    private var imageURLs: [URL] = []
    private var disposable: RACDisposable?
    private var hasExtraImages = false
    private var curURL: URL?
    private var photoBrowserIndex: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.insetsLayoutMarginsFromSafeArea = false
        }
        layoutIfNeeded()
        layout.itemSize = bounds.size
        reset()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.height < collectionView.bounds.height {
            layout.itemSize = bounds.size
            collectionView.frame = bounds
        } else {
            collectionView.frame = bounds
            layout.itemSize = bounds.size
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    deinit {
        if let disp = disposable, !disp.isDisposed {
            disp.dispose()
        }
        disposable = nil
        imageInfoList.removeAll()
    }

    var scrollProgress: Float = 0 {
        didSet {
            let p = scrollProgress
            var alpha = (p - 0.1) / (1 - 0.5 - 0.1)
            alpha = max(0, min(1, alpha))
            infoView.alpha = CGFloat(alpha)
        }
    }

    func watchImage(_ info: SPItemBannerImageInfo)  {
        if let disp = disposable {
            disp.dispose()
        }

        let s1 = info.rac_values(forKeyPath: "received", observer: self)
        let s2 = info.rac_values(forKeyPath: "length", observer: self)
        let s3 = info.rac_values(forKeyPath: "completed", observer: self)
        let s4 = info.rac_values(forKeyPath: "error", observer: self)
        let signal: RACSignal = RACSignal.combineLatest([s1, s2, s3, s4])
        disposable = signal.take(until: rac_willDeallocSignal()).subscribeNext { [weak self] (x) in
            self?.updateImageInfoView()
        }
    }

    private var curIndex: Int = 0 {
        didSet {
            watchImage(imageInfoList[curIndex])
        }
    }

    func updateExtraImages(_ extraImages: [SPGamepediaImage]) {
        var images: [URL] = []
        if let largeURL = itemData.item.qiniuLargeURL() {
            images.append(largeURL)
        }
        images.append(contentsOf: extraImages.compactMap({ $0.imageURL(.best) }))

        if images.count <= 1 {
            hasExtraImages = false
            infoView.isHidden = true
        } else {
            hasExtraImages = true
            infoView.setHidden(false, animated: true)
        }

        imageInfoList = (0..<images.count).map { (i) -> ([SPItemBannerImageInfo]) in
            let info = SPItemBannerImageInfo.init(url: images[i])
            info.index = i
            info.imageCount = images.count
            return info
        }
        imageURLs = images
        collectionView.reloadData()
        if imageInfoList.count > 0 {
            curIndex = 0
        }
    }

    func update() {
        itemData.rac_values(forKeyPath: "extraData", observer: self).subscribeNext { [weak self] (x) in
            self?.updateExtraImages(x.images)
        }
    }

    func updateImageInfoView() {
        infoView.shouldShow = imageInfoList.count > 1
        infoView.update(imageInfoList[curIndex])
    }

    func reset() {
        imageInfoList.removeAll()
        curIndex = 0
    }

    func imageInfo(for url: URL) -> SPItemBannerImageInfo? {
        return imageInfoList.first(where: { (info) -> Bool in
            return info.url.absoluteString == url.absoluteString
        })
    }

    func loadingImage(_ url: URL, received: Int, expected:  Int) {
        if let info = imageInfo(for: url) {
            info.received = received
            info.length = expected
        }
    }

    func didLoad(image url: URL, error: NSError?) {
        if let info = imageInfo(for: url) {
            info.error = error
            info.completed = true
        }
    }
}

extension SPItemBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.spItemBannerImageCell, for: indexPath)!
        cell.setImageWithURL(imageURLs[indexPath.item], progress: { [weak self] (received, expected, targetURL) in
            if let url = targetURL {
                DispatchQueue.main.async {
                    self?.loadingImage(url, received: received, expected: expected)
                }
            }
        }) { [weak self] (_image, _error, _cacheType, _imageURL) in
            guard let url = _imageURL else { return }
            self?.didLoad(image: url, error: _error)

            if let e = _error, e.code == .timeout {
                /// FIXME: 这里需要重写
//                Config.sp_config_item_detail_load_image_failed_counter ++;
//                if (Config.sp_config_item_detail_load_image_failed_counter % 5 == 0) {
//                    [UIAlertController alert:@"图片加载失败！" message:@"您可能需要科学上网"];
//                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SPItemBannerImageCell {
            let browser = IDMPhotoBrowser.init(photoURLs: imageURLs, animatedFrom: cell.imageView)!
            browser.doneButtonTopInset = UIApplication.shared.statusBarFrame.height + 12
            browser.setInitialPageIndex(UInt(indexPath.item))
            browser.delegate = self
            self.viewController?.present(browser, animated: true, completion: nil)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = Int(offsetX / scrollView.frame.width)
        curIndex = index
    }
}

extension SPItemBannerView: IDMPhotoBrowserDelegate {
    func willDisappear(_ photoBrowser: IDMPhotoBrowser!) {
        let indexPath = IndexPath.init(item: photoBrowserIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, didShowPhotoAt index: UInt) {
        photoBrowserIndex = Int(index)
    }

    func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, didDismissAtPageIndex index: UInt) {
        photoBrowser.delegate = nil
    }
}
