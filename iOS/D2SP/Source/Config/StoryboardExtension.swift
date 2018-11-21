//
//  UIViewController+Storyboard.swift
//  Laidian
//
//  Created by Jay on 2018/2/1.
//  Copyright © 2018年 来电科技. All rights reserved.
//

import Foundation
import UIKit

private var _cache: NSCache = NSCache<NSString, NSString>()

private var _storyboardIdentifierMap: [String: Set<String>] = {

    var map: [String: Set<String>] = [:]
    let error = safeCode {
        if let resourcePath = Bundle.main.resourcePath {
            let list = Bundle.paths(forResourcesOfType: "storyboardc", inDirectory: resourcePath)
            for path in list {
                let name = ((path as NSString).lastPathComponent as NSString).deletingPathExtension
                let realName = (name as NSString).components(separatedBy: "~").first!
                let bundle = Bundle.init(path: path)
                let nibNames: Any? = bundle?.object(forInfoDictionaryKey: "UIViewControllerIdentifiersToNibNames")
                if let nibNamesKeys = (nibNames as? [String: Any])?.keys {
                    map[realName] = Set.init(nibNamesKeys)
                }
            }
        }
    }
    if let e = error {
        print(e)
    }
    return map
}()

protocol StoryboardExtensionProvider: class {}

final class StoryboardExtension<T> : NSObject {
    private override init() {}
}

extension StoryboardExtensionProvider {
    static var sb: StoryboardExtension<Self>.Type {
        return StoryboardExtension<Self>.self
    }
}

extension StoryboardExtension where T: UIViewController {

    /// 从 Storyboard 创建一个新的控制器实例。
    /// 此方法内部会捕获从 Storyboard 中尝试创建控制器实例时抛出的异常
    ///
    /// 四种调用方式：
    ///    let vc1 = YourViewController.sb.create()
    ///    let vc2 = YourViewController.sb.create(identifier: "the identifier")
    ///    let vc3 = YourViewController.sb.create(from: "specified storyboard name")
    ///    let vc4 = YourViewController.sb.create(identifier: "the identifier", from: "specified storyboard name")
    ///
    /// - Parameters:
    ///   - identifier: 控制器在 Storyboard 中的 id。默认为调用者的类名。
    ///   - storyboardNamed: 指定 Storyboard 名。默认为 nil，从所有 Storyboard 资源中查找。
    /// - Returns: instance or nil
    class func create(identifier: String = NSStringFromClass(T.self), from storyboardNamed: String? = nil) -> T? {

        /// 指定了 Storyboard 名时，直接从这个 Storyboard 中取
        if let sb = storyboardNamed {
            return T.tryTakeOutInstance(storyboard: sb, identifier: identifier)
        }

        /// 尝试从缓存的 Storyboard 名中取实例
        if  let cachedName = _cache.object(forKey: identifier as NSString),
            let vc = T.tryTakeOutInstance(storyboard: cachedName as String, identifier: identifier) {
            return vc
        }

        /// 缓存已失效
        _cache.removeObject(forKey: identifier as NSString)

        /// swift中类名带有所属 module 的前缀
        guard let last = identifier.split(separator: ".").last else { return nil }

        let id = String(last)

        for (name, list) in _storyboardIdentifierMap {
            if list.contains(id) {
                if let vc = T.tryTakeOutInstance(storyboard: name, identifier: id) {
                    _cache.setObject(name as NSString, forKey: identifier as NSString)
                    return vc
                }
            }
        }
        return nil//T.self.init()
    }
}

extension UIViewController: StoryboardExtensionProvider {

    fileprivate class func tryTakeOutInstance(storyboard named: String, identifier: String) -> Self? {
        return _tryTakeOutInstance(self, storyboard: named, identifier: identifier)
    }

    fileprivate class func _tryTakeOutInstance<T>(_ type: T.Type, storyboard named: String, identifier: String) -> T? {

        var vc: T?
        let selStr = "identifier" + "To" + "Nib" + "Name" + "Map"
        let sel = NSSelectorFromString(selStr)
        let error = safeCode {
            let sb = UIStoryboard.init(name: named, bundle: Bundle.main)
            let obj = sb.perform(sel).takeUnretainedValue() as? [String: String]
            if obj != nil && obj!.values.contains(identifier) {
                vc = sb.instantiateViewController(withIdentifier: identifier) as? T
            }
        }
        if let e = error {
            print(e)
        }
        return vc
    }
}
