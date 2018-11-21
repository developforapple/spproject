//
//  UIView+LayoutExt.swift
//  AUHelp
//
//  Created by tiny (developforapple@163.com) on 2018/3/14.
//  Copyright © 2018年 tiny. All rights reserved.
//

import Foundation
import UIKit

private func _VFL(_ format: String,
                  _ metrics: [String: Any]? = nil,
                  _ views: [String: Any]? = nil) -> [NSLayoutConstraint] {
    return NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: metrics, views: views ?? [:])
}

/// 使用VFL生成多个约束实例
///
/// - Parameters:
///   - format: VFL format
///   - metrics: VFL metrics
///   - views: VFL views
/// - Returns: array of constraint
func VFL(_ format: String,
         _ metrics: [String: Any]? = nil,
         _ views: [String: Any]? = nil) -> [NSLayoutConstraint] {
    return _VFL(format, metrics, views)
}

extension UIView {

    /// 使用VFL添加单个方向的约束
    ///
    /// - Parameters:
    ///   - format: VFL format
    ///   - metrics: VFL metrics
    ///   - views: VFL views
    func VFL(_ format: String,
             _ metrics: [String: Any]? = nil,
             _ views: [String: Any]? = nil) {
        addConstraints(_VFL(format, metrics, views))
    }

    /// 使用VFL添加多个方向的约束
    ///
    /// - Parameters:
    ///   - formats: VFL format
    ///   - metrics: VFL metrics
    ///   - views: VFL views
    func VFL(_ formats: [String],
             _ metrics: [String: Any]? = nil,
             _ views: [String: Any]? = nil) {
        for format in formats {
            self.VFL(format, metrics, views)
        }
    }

    /// 使用VFL添加横向或纵向的约束
    ///
    /// - Parameters:
    ///   - vFormat: 纵向约束 VFL format
    ///   - hFormat: 横向约束 VFL format
    ///   - metrics: VFL metrics
    ///   - views: VFL views
    func VFL(V vFormat: String?,
             H hFormat: String?,
             _ metrics: [String: Any]? = nil,
             _ views: [String: Any]? = nil) {
        if let vf = vFormat {
            self.VFL(vf, metrics, views)
        }
        if let hf = hFormat {
            self.VFL(hf, metrics, views)
        }
    }
}
