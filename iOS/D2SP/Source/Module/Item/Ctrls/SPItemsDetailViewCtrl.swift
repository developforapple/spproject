//
//  SPItemsDetailViewCtrl.swift
//  D2SP
//
//  Created by bo wang on 2018/11/21.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit

class SPItemsDetailViewCtrl: YGBaseViewCtrl {

    var item: SPItem? {
        didSet {
            self.infoViewCtrl?.item = item
        }
    }
    var playerItem: SPPlayerItemDetail? {
        didSet {
            self.infoViewCtrl?.playerItem = playerItem
        }
    }

    private var infoViewCtrl: SPItemViewCtrl?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.spItemsDetailViewCtrl.spItemInfoSegueID.identifier {
            infoViewCtrl = segue.destination as? SPItemViewCtrl
            infoViewCtrl!.item = item
            infoViewCtrl!.playerItem = playerItem
        }
    }
}
