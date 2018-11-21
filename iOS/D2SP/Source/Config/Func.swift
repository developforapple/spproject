//
//  Func.swift
//  Laidian
//
//  Created by Jay on 2018/1/31.
//  Copyright © 2018年 来电科技. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable identifier_name

func synchronized(_ object: Any, _ f : (() -> Void)) {
    objc_sync_enter(object)
    f()
    objc_sync_exit(object)
}

// swiftlint:enable identifier_name
