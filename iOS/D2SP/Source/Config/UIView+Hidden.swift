//
//  UIView+Hidden.swift
//  Laidian
//
//  Created by Jay on 2018/2/1.
//  Copyright © 2018年 来电科技. All rights reserved.
//

import Foundation
import UIKit

private var _kSempahoreKey = Int8(0)
private func _sempahore(_ view: UIView) -> DispatchSemaphore {
    var sempahore = objc_getAssociatedObject(view, &_kSempahoreKey) as? DispatchSemaphore
    if sempahore == nil {
        sempahore = DispatchSemaphore.init(value: 1)
        objc_setAssociatedObject(view, &_kSempahoreKey, sempahore, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    return sempahore!
}

private var _kSempahoreQueueKey = Int8(1)
private func _sempahoreQueue(_ view: UIView) -> DispatchQueue {
    var queue = objc_getAssociatedObject(view, &_kSempahoreQueueKey) as? DispatchQueue
    if queue == nil {
        queue = DispatchQueue.init(label: "UIView+Hidden.swift semaphore queue", qos: .default, attributes: .concurrent)
        objc_setAssociatedObject(view, &_kSempahoreQueueKey, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    return queue!
}

extension UIView {

    /// 以动画方式设置UIView的hidden属性
    ///
    /// - Parameters:
    ///   - hidden: 隐藏or显示
    ///   - animated: 是否有动画
    ///   - completion: 设置结束后的回调
    func setHidden(_ hidden: Bool, animated: Bool = true, completion: (()->Void)? = nil) {

        guard animated else {
            self.isHidden = hidden
            completion?()
            return
        }

        _sempahoreQueue(self).async {
            [weak self] in
            if let view = self {
                _sempahore(view).wait()
                DispatchQueue.main.async {
                    view._executeHidden(hidden, completion: completion)
                }
            }
        }
    }

    private func _executeHidden(_ hidden: Bool, completion: (()->Void)? = nil) {

        if self.isHidden == hidden {
            completion?()
            _sempahore(self).signal()
            return
        }

        if hidden {
            let alpha = self.alpha
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { (_) in
                self.isHidden = true
                self.alpha = alpha
                completion?()
                _sempahore(self).signal()
            })
        } else {
            let alpha = self.alpha
            self.alpha = 0
            self.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = alpha
            }, completion: { (_) in
                completion?()
                _sempahore(self).signal()
            })
        }
    }
}
