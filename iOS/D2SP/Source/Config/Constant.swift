//
//  Constant.swift
//  D2SP
//
//  Created by bo wang on 2018/11/19.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import Foundation
import Darwin

let hardware_name: String = {
    var info: utsname = utsname.init()
    uname(&info)
    let machine = withUnsafePointer(to: &info.machine.0, { (ptr) -> String in
        return String.init(cString: ptr)
    })
    return machine
}()

let device_scale = UIScreen.main.nativeScale
let device_width = Int(UIScreen.main.nativeBounds.width / device_scale)
let device_height = Int(UIScreen.main.nativeBounds.height / device_scale)

let screen_scale = UIScreen.main.scale
let screen_width = Int(UIScreen.main.bounds.width / screen_scale)
let screen_height = Int(UIScreen.main.bounds.height / screen_scale)

let is_phone_ui = UI_USER_INTERFACE_IDIOM() == .phone
let is_pad_ui = UI_USER_INTERFACE_IDIOM() == .pad

let is_landscape = device_width != screen_width

let is_3_5_inch = is_phone_ui && device_width == 320 && device_height == 480
let is_4_0_inch = is_phone_ui && device_width == 320 && device_height == 568
let is_4_7_inch = is_phone_ui && device_width == 375 && device_height == 667
let is_5_5_inch = is_phone_ui && device_width == 414 && device_height == 736
let is_5_8_inch = is_phone_ui && device_width == 375 && device_height == 812
let is_6_1_inch = is_phone_ui && device_width == 414 && device_height == 896 && device_scale == 2
let is_6_5_inch = is_phone_ui && device_width == 414 && device_height == 896 && device_scale == 3
let is_infinity_display = is_5_8_inch || is_6_1_inch || is_6_5_inch

let is_iPhone = hardware_name.hasPrefix("iPhone")
let is_iPad = hardware_name.hasPrefix("iPad")
let is_iPod = hardware_name.hasPrefix("iPod")
let is_simulator: Bool = hardware_name == "x86_64" || hardware_name == "i386"

let app_name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
let app_version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
let app_version_major: Int = {
    let components = app_version.split(separator: ".")
    guard components.count > 0 else { return 0 }
    return Int(components[0]) ?? 0
}()
let app_version_minor: Int = {
    let components = app_version.split(separator: ".")
    guard components.count > 1 else { return 0 }
    return Int(components[1]) ?? 0
}()
let app_version_patch: Int = {
    let components = app_version.split(separator: ".")
    guard components.count > 2 else { return 0 }
    return Int(components[2]) ?? 0
}()
let app_version_build: Int = {
    let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    if let last = build.split(separator: ".").last {
        return Int(String(last)) ?? 0
    }
    return 0
}()
let app_documents_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
let app_library_path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
let app_caches_path = NSTemporaryDirectory()

