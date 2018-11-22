//
//  SPItemPlayablesViewCtrl.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import AVKit

class SPItemPlayablesViewCtrl: YGBaseViewCtrl {

    var playables: [SPGamepediaPlayable] = []

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout(UIScreen.main.bounds.size)
    }

    private func setupLayout(_ size: CGSize) {
        let itemPerLine: CGFloat = is_iPad ? (is_landscape ? 4.0 : 3.0) : 2.0
        let leftMargin = collectionView.contentInset.left + layout.sectionInset.left
        let rightMargin = collectionView.contentInset.right + layout.sectionInset.right
        let width = (size.width - leftMargin - rightMargin - layout.minimumInteritemSpacing * (itemPerLine - 1.0)) / itemPerLine
        let height: CGFloat = 44.0
        layout.itemSize = CGSize(width: width, height: height)
    }

    override func transitionLayout(to size: CGSize) {
        setupLayout(size)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension SPItemPlayablesViewCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playables.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.spItemPlayableCell, for: indexPath)!
        cell.nameLabel.text = playables[indexPath.item].title
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL.init(string: playables[indexPath.item].resource) {
            let vc = AVPlayerViewController.init()
            vc.player = AVPlayer.init(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}
