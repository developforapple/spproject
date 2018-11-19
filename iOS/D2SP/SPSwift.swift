//
//  SPSwift.swift
//  D2SP
//
//  Created by bo wang on 2018/11/8.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import Foundation

#if TARGET_SPAd

#warning("Swift Macro: TARGET_SPAd")

#elseif TARGET_SPPro

#warning("Swift Macro: TARGET_SPPro")

#elseif TARGET_SPOld

#warning("Swift Macro: TARGET_SPOld")

#elseif TARGET_SPOldPro

#warning("Swift Macro: TARGET_SPOldPro")

#endif
