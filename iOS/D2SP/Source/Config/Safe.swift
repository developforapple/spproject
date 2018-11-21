//
//  SafeDecode.swift
//  AUHelp
//
//  Created by bo wang on 2018/4/29.
//  Copyright © 2018年 tiny. All rights reserved.
//

import Foundation

func safe_int(_ any: Any?) -> Int {
    guard let obj = any else {return 0}
    switch obj {
    case let v as Int:      return v
    case let v as String:   return Int(v) ?? 0
    case let v as Float:    return Int(v)
    case let v as Double:   return Int(v)
    case let v as Bool:     return v ? 1 : 0
    case let v as NSNumber: return v.intValue
    case let v as NSString: return v.integerValue
    case let v as NSNull:   return 0
    default:                return 0
    }
}

func safe_float(_ any: Any?) -> Float {
    guard let obj = any else {return 0.0}
    switch obj {
    case let v as Int:      return Float(v)
    case let v as String:   return Float(v) ?? 0.0
    case let v as Float:    return v
    case let v as Double:   return Float(v)
    case let v as Bool:     return v ? 1.0 : 0.0
    case let v as NSNumber: return v.floatValue
    case let v as NSString: return v.floatValue
    case let v as NSNull:   return 0.0
    default:                return 0.0
    }
}

func safe_double(_ any: Any?) -> Double {
    guard let obj = any else {return 0.0}
    switch obj {
    case let v as Int:      return Double(v)
    case let v as String:   return Double(v) ?? 0.0
    case let v as Float:    return Double(v)
    case let v as Double:   return v
    case let v as Bool:     return v ? 1.0 : 0.0
    case let v as NSNumber: return v.doubleValue
    case let v as NSString: return v.doubleValue
    case let v as NSNull:   return 0.0
    default:                return 0.0
    }
}

func safe_string(_ any: Any?) -> String {
    guard let obj = any else {return ""}
    switch obj {
    case let v as Int:      return String(v)
    case let v as String:   return v
    case let v as Float:    return String(v)
    case let v as Double:   return String(v)
    case let v as Bool:     return "\(v)"
    case let v as NSNumber: return v.stringValue
    case let v as NSString: return v as String
    case let v as NSNull:   return "null"
    default:                return ""
    }
}

func safe_bool(_ any: Any?) -> Bool {
    guard let obj = any else {return false}

    if let v = obj as? Bool {
        return v
    }

    let v = safe_int(any)
    return v != 0
}
